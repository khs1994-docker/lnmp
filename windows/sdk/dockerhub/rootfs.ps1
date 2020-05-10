#!/usr/bin/env pwsh

<#
.SYNOPSIS
  download docker image rootfs
.DESCRIPTION
  download docker image rootfs

  PS > . $HOME\lnmp\windows\sdk\dockerhub\rootfs.ps1
  PS > rootfs alpine latest amd64 linux
.INPUTS

.OUTPUTS

.NOTES

#>
#Requires -Version 6.0.0
function rootfs($image="alpine",
                $ref="latest",
                $arch="amd64",
                $os="linux",
                $dest,
                $layersIndex=0,
                $registry=$null,
                $tokenServer="https://auth.docker.io/token",
                $tokenService="registry.docker.io"){
  # $dest 下载到哪里

  if(!($registry)){
    if($env:REGISTRY_MIRROR){
      $registry = $env:REGISTRY_MIRROR
      Write-host "==> Read `$registry from `$env:REGISTRY_MIRROR($env:REGISTRY_MIRROR)" -ForegroundColor Green
    }else{
      if($env:LNMP_CN_ENV -ne "false"){
        $registry = "hub-mirror.c.163.com"
      }else{
        $registry = "registry.hub.docker.com"
      }
    }
  }

  if($env:CI -or $CI){
    $ProgressPreference = 'SilentlyContinue'
  }

  $FormatEnumerationLimit=-1
  write-host "==> Get token ..." -ForegroundColor Green

  . $PSScriptRoot\auth\token.ps1

  $tokenServerByParser,$tokenServiceByParser = getTokenServerAndService $registry

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

. $PSScriptRoot/auth/auth.ps1

$token=getToken $image pull $tokenServer $tokenService

# write-host $token

if(!$token){
  Write-Host "==> Get token error

Please check DOCKER_USERNAME DOCKER_PASSWORD env value
" -ForegroundColor Red

  return
}

Write-Host "==> $image tags list" -ForegroundColor Green

. $PSScriptRoot/tags/list.ps1

ConvertFrom-Json (tagList $token $image $registry) | Format-List | out-host

. $PSScriptRoot/manifests/list.ps1

$result = list $token $image $ref $null $registry

if($result.schemaVersion -eq 1){
  # write-host $result

  Write-Host "==> Manifest list not found" -ForegroundColor Red

  $result = list $token $image $ref "application/vnd.docker.distribution.manifest.v2+json" $registry

  if(!$result){
    return
  }

  $digest = $result.layers[$layersIndex].digest

  Write-Host "==> Digest is $digest" -ForegroundColor Green

  if(!$digest){
    Write-Host "==> [error] Image not found, exit" -ForegroundColor Red

    return $false
  }

  . $PSScriptRoot/blobs/get.ps1

  $dest = get $token $image $digest $registry $dest

  if(!($dest)){
    return;
  }

  Write-Host "==> Download success to $dest" -ForegroundColor Green

  return $dest
}elseif($result.schemaVersion -eq 2){
  Write-host "==> Manifest list is found" -ForegroundColor Green
}else{
  Write-host "==> [error] Get manifest error, exit" -ForegroundColor Red

  return $false
}

$manifests=$result.manifests

foreach($manifest in $manifests){
  $current_arch = $manifest.platform.architecture
  $current_os = $manifest.platform.os

  if($current_arch -eq $arch -and ($current_os -eq $os)){
    $digest = $manifest.digest

    $result = list $token $image $digest "application/vnd.docker.distribution.manifest.v2+json" $registry

    $layers = $result.layers

    $digest = $layers[$layersIndex].digest

    Write-Host "==> Digest is $digest" -ForegroundColor Green

    . $PSScriptRoot/blobs/get.ps1

    $dest = get $token $image $digest $registry $dest

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
