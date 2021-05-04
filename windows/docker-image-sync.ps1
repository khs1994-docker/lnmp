#!/usr/bin/env pwsh

Import-Module $PSScriptRoot\sdk\dockerhub\manifests\get.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\manifests\upload.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\manifests\exists.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\blobs\get.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\blobs\upload.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\auth\auth.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\utils\Get-SHA.psm1

. $PSScriptRoot/sdk/dockerhub/DockerImageSpec/DockerImageSpec.ps1

if ($env:SYNC_WINDOWS -eq 'true') {
  $EXCLUDE_OS = $('x')
}
else {
  $EXCLUDE_OS = $("windows")
}
$EXCLUDE_ARCH = "s390x", "ppc64le", "386", "mips64le", "riscv64"
$EXCLUDE_VARIANT = "v6", "v5"

# $env:SOURCE_DOCKER_REGISTRY = "mirror.io"
# $env:SOURCE_DOCKER_REGISTRY=

# $env:DEST_DOCKER_REGISTRY = "default.dest.ccs.tencentyun.com"
# $env:DEST_DOCKER_REGISTRY =

Import-Module -force $PSScriptRoot/sdk/dockerhub/imageParser/imageParser.psm1

Function _upload_manifest($token, $image, $ref, $manifest_json_path, $registry) {
  New-Manifest $token $image $ref $manifest_json_path `
  $([DockerImageSpec]::manifest) $registry | out-host
}

Function _exclude_platform($manifests, $manifest_list_json_path) {
  write-host "==> exclude some platform" -ForegroundColor Blue

  $manifests_sync = $()

  foreach ($manifest in $manifests) {
    $platform = $manifest.platform

    $architecture = $platform.architecture
    $os = $platform.os
    $variant = $platform.variant

    if (($EXCLUDE_OS.indexof($os) -ne -1) `
        -or ($EXCLUDE_ARCH.indexof($architecture) -ne -1) `
        -or ($EXCLUDE_VARIANT.indexof($variant) -ne -1 )) {
      write-host "==> SKIP sync $platform" -ForegroundColor Red
      continue
    }

    write-host "==> WILL sync $platform" -ForegroundColor Green

    $manifests_sync += , $manifest
  }

  write-host "==> [end] exclude platform" -ForegroundColor Blue

  $manifest_list_json.manifests = $manifests_sync

  ConvertTo-Json -depth 5 $manifest_list_json -Compress `
  | set-content  -NoNewline "$manifest_list_json_path.sync.json"

  $manifest_list_json_path = "$manifest_list_json_path.sync.json"

  return $manifests_sync, $manifest_list_json_path
}

Function _upload_blob($dest_token, $dest_image, $digest, $dest_registry,
  $source_token, $source_image, $source_registry, $media_type
) {
  try {
    $blob_exists = Test-Blob $dest_token $dest_image $digest $dest_registry
  }
  catch {
    write-host "==> [error] check blob error, skip" -ForegroundColor Red
    if ($env:GITHUB_ACTIONS) {
      Write-Host "::warning::check blob error, skip"
      Write-Host "::endgroup::"
    }
    throw 'error'
  }

  if (!$blob_exists) {
    $blob_dest = Get-Blob $source_token $source_image $digest $source_registry
    if (!$blob_dest) {
      write-host "==> [error] get blob error" -ForegroundColor Red
      if ($env:GITHUB_ACTIONS) {
        Write-Host "::warning::get blob error"
        Write-Host "::endgroup::"
      }
      throw 'get blob error'
    }
    # upload  blob
    $result, $_ = New-Blob $dest_token $dest_image $blob_dest $media_type $dest_registry
    if (!$result) {
      if ($env:GITHUB_ACTIONS) {
        Write-Host "::warning::upload blob error"
        Write-Host "::endgroup::"
      }
      throw 'upload blob error'
    }
  }
}

Function _getSourceToken($source_registry, $source_image) {
  $env:DOCKER_PASSWORD = $null
  $env:DOCKER_USERNAME = $null

  try {
    $env:DOCKER_PASSWORD = $env:SOURCE_DOCKER_PASSWORD
    $env:DOCKER_USERNAME = $env:SOURCE_DOCKER_USERNAME
    $token = Get-DockerRegistryToken $source_image 'pull' $source_registry

    return $token
  }
  catch {
    write-host "==> get source token error" -ForegroundColor Yellow
    write-host $_.Exception
  }

  return Get-DockerRegistryToken $source_image
}

Function _getDestToken($dest_registry, $dest_image) {
  try {
    $env:DOCKER_PASSWORD = $env:DEST_DOCKER_PASSWORD
    $env:DOCKER_USERNAME = $env:DEST_DOCKER_USERNAME
    $dest_token = Get-DockerRegistryToken $dest_image 'push,pull' $dest_registry

    return $dest_token
  }
  catch {
    write-host "==> [error] get $dest_registry dest token error" `
      -ForegroundColor Red
    write-host $_.Exception
  }
}

Function _all_in_one($config) {
  # 把不支持 manifest list 的镜像组合成 manifest list
  $manifests = $()

  foreach ($platform in $config.platforms) {
    $dest = $config.dest
    if ($platform.dest) {
      $dest = $platform.dest
    }

    $manifest_json_path = _sync $platform.source $dest $platform

    if (!($manifest_json_path)) {
      write-host "==> [error] get manifest error, skip" -ForegroundColor Red

      return
    }
    write-host $manifest_json_path
    $size = (ls $manifest_json_path).Length
    $digest = Get-SHA256 $manifest_json_path
    $architecture = "amd64"
    $os = "linux"
    if ($platform.architecture) {
      $architecture = $platform.architecture
    }
    if ($platform.os) {
      $os = $platform.os
    }
    $manifest = @{
      "digest"    = "sha256:$digest";
      "mediaType" = [DockerImageSpec]::manifest;
      "platform"  = @{
        "architecture" = $architecture;
        "os"           = $os;
      };
      "size"      = $size
    }

    if ($platform.variant) {
      $manifest.platform.variant = $platform.variant
    }

    $manifests += , $manifest
  }

  write-host "==> push all-in-one manifest list" -ForegroundColor Blue

  $data = ConvertTo-Json -InputObject @{
    "mediaType"     = [DockerImageSpec]::manifest_list;
    "schemaVersion" = 2;
    "manifests"     = $manifests
  } -Compress -Depth 10

  $now_timestrap = (([DateTime]::Now.ToUniversalTime().Ticks - 621355968000000000) / 10000000).tostring().Substring(0, 10)
  $manifest_list_json_path = "$HOME/.khs1994-docker-lnmp/dockerhub/manifests/${now_timestrap}_all_in_one.json"
  Write-Output $data | Set-Content -NoNewline $manifest_list_json_path

  $dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $config.dest $false

  $dest_token = _getDestToken $dest_registry $dest_image
  New-Manifest $dest_token $dest_image $dest_ref $manifest_list_json_path `
  $([DockerImageSpec]::manifest_list) $dest_registry
}

Function _sync($source, $dest, $config) {
  if ($config.registry) {
    write-host "==> skip parse source image, read from config"

    $source_registry = $config.registry
    $source_image = $config.image
    $source_ref = $config.ref
    $source_image_with_digest = $config.digest
  }
  else {
    $source_registry, $source_image, $source_ref, $source_image_with_digest = imageParser $source
  }

  if ($config.platforms) {
    _all_in_one $config

    return
  }

  $dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false

  if ($source_image_with_digest) { $source_ref = $source_image_with_digest }

  if (!$dest_registry) {
    Write-Host "==> [error] [ $dest ] dest registry parse error, skip" `
      -ForegroundColor Red

    return
  }

  # test
  # return

  if (!$env:DEST_DOCKER_PASSWORD -or !$env:DEST_DOCKER_USERNAME) {
    write-host "==> please set `$env:DEST_DOCKER_USERNAME and `$env:DEST_DOCKER_PASSWORD" -ForegroundColor Red

    exit 1
  }

  $source_token = _getSourceToken $source_registry $source_image
  $dest_token = _getDestToken $dest_registry $dest_image

  if (!$source_token -or !$dest_token) {
    write-host "==> [error] get source or dest token error " -ForegroundColor Red

    return
  }

  # get manifest list
  $token = _getSourceToken $source_registry $source_image
  $manifest_list_json_path = Get-Manifest $token $source_image $source_ref -raw $false `
    -registry $source_registry
  if ($manifest_list_json_path) {
    $manifest_list_json = ConvertFrom-Json (Get-Content $manifest_list_json_path -raw)
  }
  else {
    $manifest_list_json = $null
  }

  if (!($manifest_list_json)) {
    write-host "==> manifest list not found" -ForegroundColor Yellow
    $manifests_list_not_exists = $true
    $manifests = $(1)
  }
  elseif ($source_image_with_digest) {
    $manifests_list_not_exists = $false
    $manifests = $manifest_list_json.manifests

    # 镜像包含 digest，digest 是 manifest list 或 manifest 的 sha256
    # 所以 dest 的 manifest list 必须和 source 的一致，不能排除 platform

    write-host "==> source image include digest, can't exclude platform" `
      -ForegroundColor Yellow
  }
  else {
    $manifests_list_not_exists = $false
    $manifests = $manifest_list_json.manifests

    if ($env:EXCLUDE_PLATFORM -eq "false") {
      write-host "==> Exclude platform is disabled" -ForegroundColor Yellow
    }
    else {
      # exclude platform
      $manifests, $manifest_list_json_path = `
        _exclude_platform $manifests $manifest_list_json_path
    }
  }

  $already_push_manifest_once = $false

  if ($env:PUSH_MANIFEST_ONCE -eq 'false' -or !$env:PUSH_MANIFEST_ONCE) {
    $already_push_manifest_once = $true
  }

  foreach ($manifest in $manifests) {
    if (!$manifests_list_not_exists) {
      $manifest_digest = $manifest.digest
      $platform = $manifest.platform

      # check manifest exists
      $dest_token = _getDestToken $dest_registry $dest_image
      try {
        $manifest_exists = Test-Manifest $dest_token $dest_image $manifest_digest -registry $dest_registry
      }
      catch {
        write-host "==> [error] check manifest error, skip" -ForegroundColor Red

        return
      }

      if ($manifest_exists) {
        write-host "==> [sync platform] Skip Handle $platform `
manifest $manifest_digest already exists" `
          -ForegroundColor Blue

        # 有的仓库不能展示 manifest list，推送一次 manifest 以显示

        if (!$already_push_manifest_once) {
          Write-Host "==> Registry maybe not show manifest list, push manifest once" -ForegroundColor Blue

          $token = _getSourceToken $source_registry $source_image
          $manifest_json_path = Get-Manifest $token $source_image $manifest_digest `
          $([DockerImageSpec]::manifest) `
            -raw $false -registry $source_registry

          # upload manifests once
          $dest_token = _getDestToken $dest_registry $dest_image
          _upload_manifest $dest_token $dest_image $dest_ref $manifest_json_path `
            $dest_registry

          $already_push_manifest_once = $true
        }

        continue
      }

      $architecture = $platform.architecture
      $os = $platform.os
      $variant = $platform.variant

      write-host "==> [sync platform] Handle $platform" -ForegroundColor Blue
    } # manifest list exists end
    else {
      # manifest list not exists
      $manifest_digest = $source_ref
      # get source manifest
      $token = _getSourceToken $source_registry $source_image
      $source_manifest_digest = Get-Manifest $token $source_image $manifest_digest `
      $([DockerImageSpec]::manifest) `
        -raw $false -registry $source_registry -return_digest_only $true
      if (!$source_manifest_digest) {
        write-host "==> [error] get source manifest error, skip" -ForegroundColor Red

        return
      }

      # check manifest digest exists in dest
      $dest_token = _getDestToken $dest_registry $dest_image
      try {
        $manifest_exists = Test-Manifest $dest_token $dest_image $source_manifest_digest -registry $dest_registry
      }
      catch {
        write-host "==> [error] check manifest error, skip" -ForegroundColor Red

        return
      }

      if ($manifest_exists) {
        write-host "==> source manifest is exists on dest, repush" -ForegroundColor Blue

        $token = _getSourceToken $source_registry $source_image
        $manifest_json_path = Get-Manifest $token $source_image $manifest_digest `
        $([DockerImageSpec]::manifest) -raw $false -registry $source_registry

        $dest_token = _getDestToken $dest_registry $dest_image
        _upload_manifest $dest_token $dest_image $dest_ref $manifest_json_path `
          $dest_registry

        return $manifest_json_path
      }
    } # manifest list not exists end

    # get manifest
    $token = _getSourceToken $source_registry $source_image
    $manifest_json_path = Get-Manifest $token $source_image $manifest_digest `
    $([DockerImageSpec]::manifest) -raw $false -registry $source_registry

    if (!$manifest_json_path) {
      write-host "==> [error] Image [ $source_image $source_ref ] `
manifest not found, skip" -ForegroundColor Red

      return
    }

    $manifest_json = ConvertFrom-Json (Get-Content $manifest_json_path -raw)

    $config_digest = $manifest_json.config.digest

    # check config blob exists
    $dest_token = _getDestToken $dest_registry $dest_image
    $source_token = _getSourceToken $source_registry $source_image

    try {
      _upload_blob $dest_token $dest_image $config_digest `
        $dest_registry $source_token $source_image $source_registry `
      $([DockerImageSpec]::container_config)
    }
    catch { write-host $_.Exception -ForegroundColor Red; return }

    # handle layers blob
    $layers = $manifest_json.layers

    foreach ($layer in $layers) {
      $layer_digest = $layer.digest
      $dest_token = _getDestToken $dest_registry $dest_image
      $source_token = _getSourceToken $source_registry $source_image

      try {
        _upload_blob $dest_token $dest_image $layer_digest `
          $dest_registry $source_token $source_image $source_registry `
          "application/octet-stream"
      }
      catch { write-host $_.Exception -ForegroundColor Red; return }
    }

    # upload manifests
    $dest_token = _getDestToken $dest_registry $dest_image
    _upload_manifest $dest_token $dest_image $dest_ref $manifest_json_path `
      $dest_registry
  }

  if ($manifests_list_not_exists) {

    write-host "==> [sync end] manifest list not exists" `
      -ForegroundColor Yellow
    if ($env:GITHUB_ACTIONS) { Write-Host "::endgroup::" }
    return $manifest_json_path
  }

  # upload manifests list
  $dest_token = _getDestToken $dest_registry $dest_image
  $length, $digest = New-Manifest $dest_token $dest_image $dest_ref $manifest_list_json_path `
  $([DockerImageSpec]::manifest_list) $dest_registry

  if (!$digest) {
    write-host "==> [error] Manifest list push error" -ForegroundColor Red
  }

  if ($dest_image_with_digest -and ("$digest" -ne $dest_image_with_digest)) {
    write-host "==> [error] push manifest list $digest not eq $dest_image_with_digest" `
      -ForegroundColor Red
  }

  write-host "==> [sync end]" -ForegroundColor Blue
  if ($env:GITHUB_ACTIONS) { Write-Host "::endgroup::" }
}

# main

if ($env:CONFIG_URL) {
  write-host "==> Get config from url"

  curl -fsSL $env:CONFIG_URL -o $PSScriptRoot/docker-image-sync.json
}

if ((Test-Path /.dockerenv) -and (Test-Path /docker-entrypoint.d/docker-image-sync.json )) {
  $sync_config = ConvertFrom-Json (Get-Content /docker-entrypoint.d/docker-image-sync.json -raw)
}
elseif (Test-Path $PSScriptRoot/docker-image-sync.json) {
  $sync_config = ConvertFrom-Json (Get-Content $PSScriptRoot/docker-image-sync.json -raw)
}

# 配置文件优先级
# 1. /docker-entrypoint.d/docker-image-sync.json
# 2. $env:CONFIG_URL
# 3. $PSScriptRoot/docker-image-sync.json

foreach ($item in $sync_config) {
  $source = $item.source
  $dest = $item.dest

  if (!$dest) {
    write-host "==> dest config not exists, use source config" -ForegroundColor Yellow
    $dest = $source
  }

  if ($env:GITHUB_ACTIONS) { Write-Host "::group::Sync [ $source ] to [ $dest ]" }
  write-host "==> [sync start] Sync [ $source ] to [ $dest ]" -ForegroundColor Blue

  _sync $source $dest $item
}
