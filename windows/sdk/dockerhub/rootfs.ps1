#!/usr/bin/env pwsh

Import-Module $PSScriptRoot/tags/list.psm1
Import-Module $PSScriptRoot/manifests/get.psm1
Import-Module $PSScriptRoot/blobs/get.psm1
Import-Module $PSScriptRoot\auth\token.psm1
Import-Module $PSScriptRoot/auth/auth.psm1
Import-Module $PSScriptRoot/registry/registry.psm1

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

  ENV:
  $env:REGISTRY_MIRROR

  $env:DOCKER_ROOTFS_PHASE="tag"            get tag only
  $env:DOCKER_ROOTFS_PHASE="manifest"       get manifest only
  $env:DOCKER_ROOTFS_PHASE="manifest list"  get manifest list only
.INPUTS

.OUTPUTS

.NOTES

#>
#Requires -Version 6.0.0

function rootfs([string]$image="alpine",
                [string]$ref="latest",
                [string]$arch="amd64",
                [string]$os="linux",
                [string]$dest,
                [int]$layersIndex=0,
                [string]$registry=$null,
                [string]$tokenServer="https://auth.docker.io/token",
                [string]$tokenService="registry.docker.io"){
  # $dest 下载到哪里

  $registry = Get-Registry $registry

  if($env:CI -or $CI){
    $ProgressPreference = 'SilentlyContinue'
  }

  $FormatEnumerationLimit=-1
  write-host "==> Get token ..." -ForegroundColor Blue

  $tokenServerByParser,$tokenServiceByParser = Get-TokenServerAndService $registry

  if($tokenServerByParser){$tokenServer=$tokenServerByParser}
  if($tokenServiceByParser){$tokenService=$tokenServiceByParser}

  if(!($image | select-string '/')){
    $image = "library/$image"
  }

  if(!$arch){$arch = "amd64"}
  if(!$os){$os = "linux"}

  ConvertFrom-Json -InputObject @"
{
    "image" : "$image",
    "ref" : "$ref",
    "arch" : "$arch",
    "os" : "$os",
    "registry" : "$registry",
    "tokenServer" : "$tokenServer",
    "tokenService" : "$tokenService",
    "layersIndex" : "$layersIndex",
}
"@ | out-host

write-host "==> Wait 3s, continue ..." -ForegroundColor Green

sleep 3

$token=Get-DockerRegistryToken $image pull $tokenServer $tokenService

# write-host $token

if(!$token){
  Write-Host "==> Get token error

Please check DOCKER_USERNAME DOCKER_PASSWORD env value
" -ForegroundColor Red

  return
}

  Write-Host "==> $image tags list" -ForegroundColor Blue

ConvertFrom-Json (Get-Tag $token $image $registry) | Format-List | out-host

  if ($env:DOCKER_ROOTFS_PHASE -eq "tag") {
    write-host "==> find `$env:DOCKER_ROOTFS_PHASE='tag' exit" -ForegroundColor Blue

    return
  }

$result = Get-Manifest $token $image $ref $null $registry

if($result){
  Write-host "==> Manifest list is found" -ForegroundColor Green
}else{
  Write-Host "==> Manifest list not found" -ForegroundColor Red

    if ($env:DOCKER_ROOTFS_PHASE -eq "manifest list") {
      write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest list' exit" -ForegroundColor Blue

      throw '404';
    }

  $result = Get-Manifest $token $image $ref "application/vnd.docker.distribution.manifest.v2+json" $registry

    if ($env:DOCKER_ROOTFS_PHASE -eq "manifest") {
      write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest' exit" -ForegroundColor Blue

      return;
    }

  if(!$result){
    return
  }

  $digest = $result.layers[$layersIndex].digest

  Write-Host "==> Digest is $digest" -ForegroundColor Green

  if(!$digest){
    Write-Host "==> [error] Image not found, exit" -ForegroundColor Red

    return $false
  }

  $dest = Get-Blob $token $image $digest $registry $dest

  if(!($dest)){
    return;
  }

  Write-Host "==> Download success to $dest" -ForegroundColor Green

  return $dest
}

  if ($env:DOCKER_ROOTFS_PHASE -eq "manifest list") {
    write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest list' exit" -ForegroundColor Blue

    ConvertTo-Json $result | out-host

    return
  }

$manifests=$result.manifests

foreach($manifest in $manifests){
  $current_arch = $manifest.platform.architecture
  $current_os = $manifest.platform.os

  if($current_arch -eq $arch -and ($current_os -eq $os)){
    $digest = $manifest.digest

    $result = Get-Manifest $token $image $digest "application/vnd.docker.distribution.manifest.v2+json" $registry

      if ($env:DOCKER_ROOTFS_PHASE -eq "manifest") {
        write-host "==> find `$env:DOCKER_ROOTFS_PHASE='manifest' exit" -ForegroundColor Blue

        ConvertTo-Json $result | out-host

        return;
      }

    $layers = $result.layers

    $digest = $layers[$layersIndex].digest

    Write-Host "==> Blob(layer) digest is $digest" -ForegroundColor Green

    $dest = Get-Blob $token $image $digest $registry $dest

    if(!($dest)){
      return;
    }

    Write-Host "==> Download success to $dest" -ForegroundColor Green

    return $dest
  }
  }

  Write-Host "==> Can't find ${image}:$ref $os $arch image" -ForegroundColor Red
}

# rootfs khs1994/hello-world latest '' '' '' 0 `
# ccr.ccs.tencentyun.com
# https://ccr.ccs.tencentyun.com/service/token token-service

# rootfs khs1994/hello-world latest '' '' '' 0 `
# registry.cn-hangzhou.aliyuncs.com
