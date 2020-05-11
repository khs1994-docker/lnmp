#!/usr/bin/env pwsh

if ($IsWindows) {
}
else {
  Import-Alias -Force $PSScriptRoot/pwsh-alias.txt
}

$manifest_list_media_type = "application/vnd.docker.distribution.manifest.list.v2+json"
$manifest_media_type = "application/vnd.docker.distribution.manifest.v2+json"
$image_media_type = "application/vnd.docker.container.image.v1+json"

if ($env:SYNC_WINDOWS -eq 'true') {
  $EXCLUDE_OS = $('w')
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

Function _sync() {
  $source_registry, $source_image, $source_ref = imageParser $source
  $dest_registry, $dest_image, $dest_ref = imageParser $dest $false

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
    . $PSScriptRoot/sdk/dockerhub/auth/token.ps1

    try {
      $tokenServer, $tokenService = getTokenServerAndService $source_registry
      . $PSScriptRoot/sdk/dockerhub/auth/auth.ps1
      if (!$tokenServer) {
        throw "tokenServer not found"
      }
      $token = getToken $source_image 'pull' $tokenServer $tokenService

      return $token
    }
    catch {
      write-host "==> get source token error" -ForegroundColor Yellow
      write-host $_.Exception
    }

    return getToken $source_image
  }

  Function _getDestToken() {
    . $PSScriptRoot/sdk/dockerhub/auth/token.ps1
    try {
      $tokenServer, $tokenService = getTokenServerAndService $dest_registry
      if (!$tokenServer) {
        throw "tokenServer not found"
      }

      . $PSScriptRoot/sdk/dockerhub/auth/auth.ps1
      $env:DOCKER_PASSWORD = $env:DEST_DOCKER_PASSWORD
      $env:DOCKER_USERNAME = $env:DEST_DOCKER_USERNAME
      $dest_token = getToken $dest_image 'push,pull' $tokenServer $tokenService

      return $dest_token
    }
    catch {
      write-host "==> [error] get $dest_registry dest token error" -ForegroundColor Red
      write-host $_.Exception
    }
  }

  if (!$env:DEST_DOCKER_PASSWORD -or !$env:DEST_DOCKER_USERNAME) {
    write-host "==> please set `$env:DEST_DOCKER_PASSWORD and `$env:DEST_DOCKER_USERNAME" -ForegroundColor Red

    exit 1
  }

  . $PSScriptRoot/sdk/dockerhub/manifests/list.ps1

  $token = _getSourceToken
  $manifest_list_json_path = list $token $source_image $source_ref -raw $false -registry $source_registry
  if ($manifest_list_json_path) {
    $manifest_list_json = ConvertFrom-Json (cat $manifest_list_json_path -raw)
  }
  else {
    $manifest_list_json = $null
  }

  if ((!$manifest_list_json) -or ($manifest_list_json.schemaVersion -eq 1)) {
    $manifests_list_not_exists = $true
    $manifests = $(1)
  }
  else {
    $manifests_list_not_exists = $false
    $manifests = $manifest_list_json.manifests

    # exclude
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
  }

  foreach ($manifest in $manifests) {
    if (!$manifests_list_not_exists) {
      $manifest_digest = $manifest.digest
      $platform = $manifest.platform

      $architecture = $platform.architecture
      $os = $platform.os
      $variant = $platform.variant

      write-host "==> [sync platform] Handle $platform" -ForegroundColor Blue
    }
    else {
      $manifest_digest = $dest_ref
    }

    $token = _getSourceToken
    $manifest_json_path = list $token $source_image $manifest_digest $manifest_media_type `
      -raw $false -registry $source_registry

    if (!$manifest_json_path) {
      write-host "==> [error] Image $source_image $source_ref manifest not found, skip" -ForegroundColor Red

      return
    }

    $manifest_json = ConvertFrom-Json (cat $manifest_json_path -raw)

    . $PSScriptRoot/sdk/dockerhub/blobs/get.ps1

    $config_digest = $manifest_json.config.digest
    . $PSScriptRoot/sdk/dockerhub/blobs/upload.ps1
    $dest_token = _getDestToken
    if (_isExists $dest_token $dest_image $config_digest.split(':')[-1] $dest_registry) {

    }
    else {
      $token = _getSourceToken
      $blob_dest = get $token $source_image $config_digest $source_registry
      if (!$blob_dest) {
        write-host "==> [error] get blob error" -ForegroundColor Red

        return
      }
      # upload image config blob
      $dest_token = _getDestToken
      upload $dest_token $dest_image $blob_dest $image_media_type $dest_registry
    }

    $layers = $manifest_json.layers

    foreach ($layer in $layers) {
      $layer_digest = $layer.digest
      $dest_token = _getDestToken
      if (_isExists $dest_token $dest_image $layer_digest.split(':')[-1] $dest_registry) {

      }
      else {
        $token = _getSourceToken
        $blob_dest = get $token $source_image $layer_digest -registry $source_registry
        if (!$blob_dest) {
          write-host "==> [error] get blob error" -ForegroundColor Red

          return
        }
        # upload image layer blob
        $dest_token = _getDestToken
        upload $dest_token $dest_image $blob_dest "application/octet-stream" $dest_registry
      }
    }

    . $PSScriptRoot/sdk/dockerhub/manifests/upload.ps1
    # upload manifests
    $dest_token = _getDestToken
    upload $dest_token $dest_image $dest_ref $manifest_json_path `
      $manifest_media_type $dest_registry
  }

  if ($manifests_list_not_exists) {
    write-host "==> [sync end] manifest list not exists, skip " -ForegroundColor Yellow

    return
  }

  . $PSScriptRoot/sdk/dockerhub/manifests/upload.ps1
  # upload manifests list
  $dest_token = _getDestToken
  upload $dest_token $dest_image $dest_ref $manifest_list_json_path `
    $manifest_list_media_type $dest_registry

  write-host "==> [sync end]" -ForegroundColor Blue
}

if (!(Test-Path $PSScriptRoot/docker-image-sync.json)) {
  write-host "==> file [ $PSScriptRoot/docker-image-sync.json ] not exists" -ForegroundColor Red

  exit 1
}

$sync_config = ConvertFrom-Json (cat $PSScriptRoot/docker-image-sync.json -raw)

foreach ($item in $sync_config) {
  $source = $item.source
  $dest = $item.dest

  write-host "==> [sync start] Sync [ $source ] to [ $dest ]" -ForegroundColor Blue

  _sync $source $dest
}
