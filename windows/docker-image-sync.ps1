#!/usr/bin/env pwsh

if ($IsWindows) {
}
else {
  Import-Alias -Force $PSScriptRoot/pwsh-alias.txt
}

$manifest_list_media_type = "application/vnd.docker.distribution.manifest.list.v2+json"
$manifest_media_type = "application/vnd.docker.distribution.manifest.v2+json"
$image_media_type = "application/vnd.docker.container.image.v1+json"

$EXCLUDE_ARCH = "s390x", "ppc64le", "386"
$EXCLUDE_VARIANT = "v6", "v5"

Function _sync() {
  $source_image, $source_ref = $source.split(':')
  $source_registry = $env:SOURCE_DOCKER_REGISTRY
  $dest_image, $dest_ref = $dest.split(':')
  $dest_registry, $dest_image = $dest_image.split('/', 2)

  if (!$source_registry) {
    $source_registry = 'hub-mirror.c.163.com'
  }

  write-host (Convertfrom-Json -InputObject @"
{
    "registry": "$source_registry",
    "image": "$source_image",
    "ref":"$source_ref"
}
"@) -ForegroundColor Red

  write-host (Convertfrom-Json -InputObject @"
{
    "registry": "$dest_registry",
    "image": "$dest_image",
    "ref":"$dest_ref"
  }
"@) -ForegroundColor Red

  Function _getSourceToken() {
    $env:DOCKER_PASSWORD = $null
    $env:DOCKER_USERNAME = $null

    . $PSScriptRoot/sdk/dockerhub/auth/auth.ps1
    $token = getToken $source_image

    return $token
  }

  Function _getDestToken() {
    . $PSScriptRoot/sdk/dockerhub/auth/token.ps1
    $tokenServer, $tokenService = getTokenServerAndService $dest_registry

    . $PSScriptRoot/sdk/dockerhub/auth/auth.ps1
    $env:DOCKER_PASSWORD = $env:DEST_DOCKER_PASSWORD
    $env:DOCKER_USERNAME = $env:DEST_DOCKER_USERNAME
    $dest_token = getToken $dest_image 'push,pull' $tokenServer $tokenService

    return $dest_token
  }

  if (!$env:DEST_DOCKER_PASSWORD -or !$env:DEST_DOCKER_USERNAME) {
    write-host "==> please set `$env:DEST_DOCKER_PASSWORD and `$env:DEST_DOCKER_USERNAME" -ForegroundColor Red

    exit
  }

  . $PSScriptRoot/sdk/dockerhub/manifests/list.ps1

  $token = _getSourceToken
  $manifest_list_json_path = list $token $source_image $source_ref -raw $false -registry $source_registry
  $manifest_list_json = ConvertFrom-Json (cat $manifest_list_json_path -raw)

  if ($manifest_list_json.schemaVersion -eq 1) {
    $manifests_list_not_exists = $true
    $manifests = $(1)
  }
  else {
    $manifests_list_not_exists = $false
    $manifests = $manifest_list_json.manifests
  }

  foreach ($manifest in $manifests) {
    if (!$manifests_list_not_exists) {
      $manifest_digest = $manifest.digest
      $platform = $manifest.platform

      $architecture = $platform.architecture
      $os = $platform.os
      $variant = $platform.variant

      # if ($EXCLUDE_ARCH.indexof($architecture) -ne -1 ){
      #   write-host "==> SKIP handle $platform" -ForegroundColor Red
      #   continue
      # }

      # if ($EXCLUDE_VARIANT.indexof($variant) -ne -1 ){
      #   write-host "==> SKIP handle $platform" -ForegroundColor Red
      #   continue
      # }

    }
    else {
      $manifest_digest = $dest_ref
    }

    $token = _getSourceToken
    $manifest_json_path = list $token $source_image $manifest_digest $manifest_media_type `
      -raw $false -registry $source_registry
    $manifest_json = ConvertFrom-Json (cat $manifest_json_path -raw)

    . $PSScriptRoot/sdk/dockerhub/blobs/get.ps1

    $config_digest = $manifest_json.config.digest
    . $PSScriptRoot/sdk/dockerhub/blobs/upload.ps1
    $dest_token = _getDestToken
    if (_isExists $dest_token $dest_image $config_digest.split(':')[-1] $dest_registry) {

    }
    else {
      $token = _getSourceToken
      $blob_dest = get $token $source_image $config_digest
      if (!$blob_dest) {
        write-host "==> get blob error" -ForegroundColor Red

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
          write-host "==> get blob error" -ForegroundColor Red

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
    upload $dest_token $dest_image $manifest_digest $manifest_json_path `
      $manifest_media_type $dest_registry
  }

  if ($manifests_list_not_exists) {
    write-host "==> manifest list not exists, skip " -ForegroundColor Yellow

    return
  }

  . $PSScriptRoot/sdk/dockerhub/manifests/upload.ps1
  # upload manifests list
  $dest_token = _getDestToken
  upload $dest_token $dest_image $dest_ref $manifest_list_json_path `
    $manifest_list_media_type $dest_registry
}

$sync_config = ConvertFrom-Json (cat $PSScriptRoot/docker-image-sync.json -raw)

foreach ($item in $sync_config) {
  $source = $item.source
  $dest = $item.dest

  write-host "==> Sync [ $source ] to [ $dest ]" -ForegroundColor Blue

  _sync $source $dest
}
