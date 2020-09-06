#!/usr/bin/env pwsh

Import-Module $PSScriptRoot/tags/list.psm1
Import-Module $PSScriptRoot/manifests/get.psm1
Import-Module $PSScriptRoot/blobs/get.psm1
Import-Module $PSScriptRoot/auth/auth.psm1
Import-Module $PSScriptRoot/registry/registry.psm1

. $PSScriptRoot/DockerImageSpec/DockerImageSpec.ps1

# $env:DOCKER_ROOTFS_PHASE="tag"
# $env:DOCKER_ROOTFS_PHASE="manifest"
# $env:DOCKER_ROOTFS_PHASE="manifest list"

<#
.SYNOPSIS
  download docker image rootfs
.DESCRIPTION
  download docker image rootfs

  PS > . $HOME\lnmp\windows\sdk\dockerhub\rootfs.ps1
  PS > rootfs alpine latest amd64 linux

  PS > rootfs alpine -phase "tag"
  PS > rootfs alpine -phase "manifest"
  PS > rootfs alpine -phase "manifest list"

  ENV:
  $env:LNMP_CACHE="~/.khs1994-docker-lnmp"
  $env:REGISTRY_MIRROR

  $env:DOCKER_USERNAME
  $env:DOCKER_PASSWORD
.INPUTS

.OUTPUTS

.NOTES

#>
#Requires -Version 6.0.0

function rootfs([string]$image = "alpine",
  [string]$ref = "latest",
  [string]$arch = "amd64",
  [string]$os = "linux",
  [string]$dest,
  $layersIndex = 0,
  [string]$registry = $null,
  [string]$phase = $null) {
  # $dest 下载到哪里

  # $layersIndex = 0
  # $layersIndex = 0,1
  # $layersIndex = 'config',0,1
  # $layersIndex = 'all'

  if ($phase -eq 'tag') {
    $env:DOCKER_ROOTFS_PHASE = "tag"
  }

  if ($phase -eq 'manifest') {
    $env:DOCKER_ROOTFS_PHASE = "manifest"
  }

  if ($phase -eq 'manifest list') {
    $env:DOCKER_ROOTFS_PHASE = "manifest list"
  }

  if(!$phase){
    $env:DOCKER_ROOTFS_PHASE = $null
  }

  $registry = Get-Registry $registry

  if ($env:CI -or $CI) {
    $ProgressPreference = 'SilentlyContinue'
  }

  $FormatEnumerationLimit = -1

  if (!($image | select-string '/')) {
    $image = "library/$image"
  }

  if (!$arch) { $arch = "amd64" }
  if (!$os) { $os = "linux" }

  ConvertFrom-Json -InputObject @"
{
    "image" : "$image",
    "ref" : "$ref",
    "arch" : "$arch",
    "os" : "$os",
    "registry" : "$registry",
    "layersIndex" : "$layersIndex",
}
"@ | out-host

  write-host "==> Get token ..." -ForegroundColor Blue

  $token = Get-DockerRegistryToken $image pull $registry

  # write-host $token

  if (!$token) {
    Write-Host "==> Get token error

Please check DOCKER_USERNAME DOCKER_PASSWORD env value
" -ForegroundColor Red

    return
  }

  if ($env:DOCKER_ROOTFS_PHASE -eq "tag") {
    write-host "==> find `$env:DOCKER_ROOTFS_PHASE='tag', exit" -ForegroundColor Blue

    Write-Host "==> $image tags list" -ForegroundColor Blue

    ConvertFrom-Json (Get-Tag $token $image $registry) | Format-List | out-host

    return
  }

  $result = Get-Manifest $token $image $ref $null $registry

  if (!$result) {
    Write-Host "==> Manifest list not found" -ForegroundColor Red

    if ($env:DOCKER_ROOTFS_PHASE -eq "manifest list") {
      write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest list', exit" -ForegroundColor Blue

      throw '404';
    }

    $result = Get-Manifest $token $image $ref $([DockerImageSpec]::manifest) $registry

    if ($env:DOCKER_ROOTFS_PHASE -eq "manifest") {
      write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest', exit" -ForegroundColor Blue

      return ConvertTo-Json -Depth 5 $result
    }

    if (!$result) {
      return
    }

    $dests = $()

    if ($layersIndex -eq 'all') {
      $layersIndex = -1..($result.layers.count - 1)
      $layersIndex[0] = 'config'
    }

    foreach ($index in $layersIndex) {
      write-host "==> Download layers index $index" -ForegroundColor Blue

      if ($index -eq 'config') {
        $digest = $result.config.digest
      }
      else {
        $digest = $result.layers[$index].digest
      }

      if (!$digest) {
        Write-Host "==> [error] get blob error" -ForegroundColor Red

        $dests += , $false

        continue
      }

      $dest = Get-Blob $token $image $digest $registry $dest

      if ($dest -eq $false) {
        write-host "==> Download failed" -ForegroundColor Red

        return $false;
      }

      Write-Host "==> Download success to $dest" -ForegroundColor Green

      $dests += , $dest
      $dest = $null
    }

    if ($dests.Count -eq 1) {
      return $dests[0]
    }

    return $dests
  }

  if ($env:DOCKER_ROOTFS_PHASE -eq "manifest list") {
    write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest list', exit" -ForegroundColor Blue

    return ConvertTo-Json -Depth 5 $result
  }

  $manifests = $result.manifests

  foreach ($manifest in $manifests) {
    $current_arch = $manifest.platform.architecture
    $current_os = $manifest.platform.os

    if ($current_arch -eq $arch -and ($current_os -eq $os)) {
      $digest = $manifest.digest

      $result = Get-Manifest $token $image $digest $([DockerImageSpec]::manifest) $registry

      if ($env:DOCKER_ROOTFS_PHASE -eq "manifest") {
        write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest', exit" -ForegroundColor Blue

        return ConvertTo-Json -Depth 5 $result
      }

      $layers = $result.layers
      $dests = $()

      if ($layersIndex -eq 'all') {
        $layersIndex = -1..($result.layers.count - 1)
        $layersIndex[0] = 'config'
      }

      foreach ($index in $layersIndex) {
        write-host "==> Download layers index $index" -ForegroundColor Blue

        if ($index -eq 'config') {
          $digest = $result.config.digest
        }
        else {
          $digest = $layers[$index].digest
        }

        if (!$digest) {
          Write-Host "==> [error] get blob error" -ForegroundColor Red

          $dests += , $false

          continue
        }

        $dest = Get-Blob $token $image $digest $registry $dest

        if ($dest -eq $false) {
          write-host "==> Download failed" -ForegroundColor Red

          return $false;
        }

        Write-Host "==> Download success to $dest" -ForegroundColor Green

        $dests += , $dest

        $dest = $null
      }

      if ($dests.Count -eq 1) {
        return $dests[0]
      }

      return $dests
    }
  }

  Write-Host "==> Can't find ${image}:$ref $os $arch image" -ForegroundColor Red
}

# rootfs khs1994/hello-world latest '' '' '' 0 `
# ccr.ccs.tencentyun.com
# https://ccr.ccs.tencentyun.com/service/token token-service

# rootfs khs1994/hello-world latest '' '' '' 0 `
# registry.cn-hangzhou.aliyuncs.com
