#!/usr/bin/env pwsh

if ($IsWindows) {
}
else {
  Import-Alias -Force $PSScriptRoot/pwsh-alias.txt
}

Import-Module $PSScriptRoot\sdk\dockerhub\manifests\get.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\manifests\upload.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\manifests\exists.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\blobs\get.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\blobs\upload.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\auth\token.psm1
Import-Module $PSScriptRoot\sdk\dockerhub\auth\auth.psm1

$manifest_list_media_type = "application/vnd.docker.distribution.manifest.list.v2+json"
$manifest_media_type = "application/vnd.docker.distribution.manifest.v2+json"
$image_media_type = "application/vnd.docker.container.image.v1+json"

if ($env:SYNC_WINDOWS -eq 'true') {
  $EXCLUDE_OS = $('x')
}
else {
  $EXCLUDE_OS = $("windows")
}
$EXCLUDE_ARCH = "s390x", "ppc64le", "386"
$EXCLUDE_VARIANT = "v6", "v5"

# $env:SOURCE_DOCKER_REGISTRY = "mirror.io"
# $env:SOURCE_DOCKER_REGISTRY=

# $env:DEST_DOCKER_REGISTRY = "default.dest.ccs.tencentyun.com"
# $env:DEST_DOCKER_REGISTRY =

Import-Module -force $PSScriptRoot/sdk/dockerhub/imageParser/imageParser.psm1

Function _upload_manifest($token, $image, $ref, $manifest_json_path, $registry) {
  New-Manifest $token $image $ref $manifest_json_path `
    $manifest_media_type $registry
}

Function _exclude_platform($manifests, $manifest_list_json_path) {
  write-host "==> exclude some platform" -ForegroundColor Blue
  $manifests_count = $manifests.Count

  $manifests_sync = 0..($manifests_count - 1)

  $i = -1
  $manifests_sync_count = 0
  foreach ($manifest in $manifests) {
    $i++
    $manifest_digest = $manifest.digest
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

    $manifests_sync_count++
    $manifests_sync[$i] = $manifest
  }

  write-host "==> [end] exclude platform" -ForegroundColor Blue

  $i = -1
  $manifests = 0..($manifests_sync_count - 1 )

  foreach ($item in $manifests_sync) {
    if (!($item -is [int])) {
      $i++
      $manifests[$i] = $item
    }
  }
  $manifest_list_json.manifests = $manifests

  ConvertTo-Json -depth 5 $manifest_list_json -Compress `
  | set-content  -NoNewline "$manifest_list_json_path.sync.json"

  $manifest_list_json_path = "$manifest_list_json_path.sync.json"

  return $manifests, $manifest_list_json_path
}

Function _upload_blob($dest_token, $dest_image, $digest, $dest_registry,
  $source_token, $source_image, $source_registry, $media_type
) {
  try {
    $blob_exists = Test-Blob $dest_token $dest_image $digest.split(':')[-1] `
      $dest_registry
  }
  catch {
    write-host "==> [error] check blob error, skip" -ForegroundColor Red

    throw 'error'
  }

  if (!$blob_exists) {
    $blob_dest = Get-Blob $source_token $source_image $digest $source_registry
    if (!$blob_dest) {
      write-host "==> [error] get blob error" -ForegroundColor Red

      throw 'error'
    }
    # upload  blob
    New-Blob $dest_token $dest_image $blob_dest $media_type $dest_registry
  }
}

Function _sync() {
  $source_registry, $source_image, $source_ref, $source_image_with_digest = imageParser $source
  $dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false

  if ($source_image_with_digest) { $source_ref = $source_image_with_digest }

  if (!$dest_registry) {
    Write-Host "==> [error] [ $dest ] dest registry parse error, skip" `
      -ForegroundColor Red

    return
  }

  # test
  # return

  Function _getSourceToken() {
    $env:DOCKER_PASSWORD = $null
    $env:DOCKER_USERNAME = $null

    try {
      $tokenServer, $tokenService = Get-TokenServerAndService $source_registry
      if (!$tokenServer) {
        throw "tokenServer not found"
      }

      $env:DOCKER_PASSWORD = $env:SOURCE_DOCKER_PASSWORD
      $env:DOCKER_USERNAME = $env:SOURCE_DOCKER_USERNAME
      $token = Get-DockerRegistryToken $source_image 'pull' $tokenServer $tokenService

      return $token
    }
    catch {
      write-host "==> get source token error" -ForegroundColor Yellow
      write-host $_.Exception
    }

    return Get-DockerRegistryToken $source_image
  }

  Function _getDestToken() {
    try {
      $tokenServer, $tokenService = Get-TokenServerAndService $dest_registry
      if (!$tokenServer) {
        throw "tokenServer not found"
      }

      $env:DOCKER_PASSWORD = $env:DEST_DOCKER_PASSWORD
      $env:DOCKER_USERNAME = $env:DEST_DOCKER_USERNAME
      $dest_token = Get-DockerRegistryToken $dest_image 'push,pull' $tokenServer $tokenService

      return $dest_token
    }
    catch {
      write-host "==> [error] get $dest_registry dest token error" `
        -ForegroundColor Red
      write-host $_.Exception
    }
  }

  if (!$env:DEST_DOCKER_PASSWORD -or !$env:DEST_DOCKER_USERNAME) {
    write-host "==> please set `$env:DEST_DOCKER_PASSWORD and `$env:DEST_DOCKER_USERNAME" -ForegroundColor Red

    exit 1
  }

  $source_token = _getSourceToken
  $dest_token = _getDestToken

  if (!$source_token -or !$dest_token) {
    write-host "==> [error] get source or dest token error " -ForegroundColor Red

    return
  }

  # get manifest list
  $token = _getSourceToken
  $manifest_list_json_path = Get-Manifest $token $source_image $source_ref -raw $false `
    -registry $source_registry
  if ($manifest_list_json_path) {
    $manifest_list_json = ConvertFrom-Json (cat $manifest_list_json_path -raw)
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

    # 镜像包含 digest，是 manifest list 或 manifest 的 sha256
    # dest 的 manifest list 必须和 source 的一致，不能排除 platform

    write-host "==> source image include digest, can't exclude platform" `
      -ForegroundColor Yellow
  }
  else {
    $manifests_list_not_exists = $false
    $manifests = $manifest_list_json.manifests

    if ($env:EXCLUDE_PLATFORM -eq "false") {

    }
    else {
      # exclude platform
      $manifests, $manifest_list_json_path = `
        _exclude_platform $manifests $manifest_list_json_path
    }
  }

  $push_manifest_once = $false

  foreach ($manifest in $manifests) {
    if (!$manifests_list_not_exists) {
      $manifest_digest = $manifest.digest
      $platform = $manifest.platform

      # check manifest exists
      $dest_token = _getDestToken
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

        if (!$push_manifest_once) {
          Write-Host "==> Push manifest once" -ForegroundColor Blue

          $token = _getSourceToken
          $manifest_json_path = Get-Manifest $token $source_image $manifest_digest `
            $manifest_media_type `
            -raw $false -registry $source_registry

          # upload manifests once
          $dest_token = _getDestToken
          _upload_manifest $dest_token $dest_image $dest_ref $manifest_json_path `
            $dest_registry

          $push_manifest_once = $true
        }

        continue;
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
      $token = _getSourceToken
      $source_manifest_digest = Get-Manifest $token $source_image $manifest_digest `
        $manifest_media_type `
        -raw $false -registry $source_registry -return_digest_only $true
      if (!$source_manifest_digest) {
        write-host "==> [error] get source manifest error, skip" -ForegroundColor Red

        return
      }

      # check manifest digest exists in dest
      $dest_token = _getDestToken
      try {
        $manifest_exists = Test-Manifest $dest_token $dest_image $source_manifest_digest -registry $dest_registry
      }
      catch {
        write-host "==> [error] check manifest error, skip" -ForegroundColor Red

        return
      }

      if ($manifest_exists) {
        write-host "==> source manifest is exists on dest, repush" -ForegroundColor Blue

        $token = _getSourceToken
        $manifest_json_path = Get-Manifest $token $source_image $manifest_digest `
          $manifest_media_type -raw $false -registry $source_registry

        $dest_token = _getDestToken
        _upload_manifest $dest_token $dest_image $dest_ref $manifest_json_path `
          $dest_registry

        return;
      }
    } # manifest list not exists end

    # get manifest
    $token = _getSourceToken
    $manifest_json_path = Get-Manifest $token $source_image $manifest_digest `
      $manifest_media_type -raw $false -registry $source_registry

    if (!$manifest_json_path) {
      write-host "==> [error] Image [ $source_image $source_ref ] `
manifest not found, skip" -ForegroundColor Red

      return
    }

    $manifest_json = ConvertFrom-Json (cat $manifest_json_path -raw)

    $config_digest = $manifest_json.config.digest

    # check config blob exists
    $dest_token = _getDestToken
    $source_token = _getSourceToken

    try {
      _upload_blob $dest_token $dest_image $config_digest `
        $dest_registry $source_token $source_image $source_registry $image_media_type
    }
    catch { write-host $_.Exception ; return }

    # handle layers blob
    $layers = $manifest_json.layers

    foreach ($layer in $layers) {
      $layer_digest = $layer.digest
      $dest_token = _getDestToken
      $source_token = _getSourceToken

      try {
        _upload_blob $dest_token $dest_image $layer_digest `
          $dest_registry $source_token $source_image $source_registry `
          "application/octet-stream"
      }
      catch { write-host $_.Exception ; return }
    }

    # upload manifests
    $dest_token = _getDestToken
    _upload_manifest $dest_token $dest_image $dest_ref $manifest_json_path `
      $dest_registry
  }

  if ($manifests_list_not_exists) {
    write-host "==> [sync end] manifest list not exists" `
      -ForegroundColor Yellow

    return
  }

  # upload manifests list
  $dest_token = _getDestToken
  $length, $digest = New-Manifest $dest_token $dest_image $dest_ref $manifest_list_json_path `
    $manifest_list_media_type $dest_registry

  if ($dest_image_with_digest -and ("sha256:$digest" -ne $dest_image_with_digest)) {
    write-host "==> [error] push manifest list $digest not eq $dest_image_with_digest" `
      -ForegroundColor Red
  }

  write-host "==> [sync end]" -ForegroundColor Blue
}

# main

if (!(Test-Path $PSScriptRoot/docker-image-sync.json)) {
  write-host "==> file [ $PSScriptRoot/docker-image-sync.json ] not exists" `
    -ForegroundColor Red

  exit 1
}

$sync_config = ConvertFrom-Json (cat $PSScriptRoot/docker-image-sync.json -raw)

foreach ($item in $sync_config) {
  $source = $item.source
  $dest = $item.dest

  if (!$dest) {
    write-host "==> dest config not exists, use source config" -ForegroundColor Yellow
    $dest = $source
  }

  write-host "==> [sync start] Sync [ $source ] to [ $dest ]" -ForegroundColor Blue

  _sync $source $dest
}
