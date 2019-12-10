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
                $dist,
                $layersIndex=0,
                $registry="dockerhub.azk8s.cn",
                $tokenServer="https://auth.docker.io/token",
                $tokenService="registry.docker.io"){

  $FormatEnumerationLimit=-1
  write-host "==> Get token ..."

  try{
    $WWW_Authenticate = (Invoke-WebRequest https://$registry/v2/x/y/manifests/latest `
      -Method Head -MaximumRedirection 0 -UserAgent "Docker-Client/19.03.5 (Windows)" `
      ).Headers['WWW-Authenticate']
  }catch{
    $headers = $_.Exception.Response.Headers
    # write-host $headers
    if($headers.contains('WWW-Authenticate')){
      # write-host (($headers.toString())[0])
      $WWW_Authenticate = $headers['WWW-Authenticate']

      if(!$WWW_Authenticate){
        $headers = $headers.toString().replace(': ','=')

        $WWW_Authenticate = (ConvertFrom-StringData $headers)['WWW-Authenticate']
      }
    }
  }

if($WWW_Authenticate){
  $result = $WWW_Authenticate.split(',').split('=')

  if($result[0] -eq 'Bearer realm'){
    $tokenServer=$result[1].replace('"','')
  }

  if($result[2] -eq 'service'){
    $tokenService=$result[3].replace('"','')
  }
}

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

write-host "==> Wait 3s, continue ..."

sleep 3

. $PSScriptRoot/auth/auth.ps1

$token=getToken $image pull $tokenServer $tokenService

# write-host $token

if(!$token){
  Write-Warning "Get token error

Please check DOCKER_USERNAME DOCKER_PASSWORD env value
"

  return
}

Write-Warning "$image tags list"

. $PSScriptRoot/tags/list.ps1

ConvertFrom-Json (tagList $token $image $registry) | Format-List | out-host

. $PSScriptRoot/manifests/list.ps1

$result = list $token $image $ref $null $registry

if($result.schemaVersion -eq 1){
  # write-host $result

  Write-Warning "manifest list not found"

  $result = list $token $image $ref "application/vnd.docker.distribution.manifest.v2+json" $registry

  if(!$result){
    return
  }

  $digest = $result.layers[$layersIndex].digest

  Write-Warning "Digest is $digest"

  if(!$digest){
    Write-Warning "image not found, exit"

    return 1
  }

  . $PSScriptRoot/blobs/get.ps1

  $dist = get $token $image $digest $registry $dist

  Write-Warning "Download success to $dist"

  return $dist
}elseif($result.schemaVersion -eq 2){
  Write-Warning "manifest list is found"
}else{
  Write-Warning "Get manifest error, exit"

  return 1
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

    Write-Warning "Digest is $digest"

    . $PSScriptRoot/blobs/get.ps1

    $dist = get $token $image $digest $registry $dist

    Write-Warning "Download success to $dist"

    return $dist
  }
  }

  Write-Warning "Can't find ${image}:$ref $os $arch image"
}

# rootfs khs1994/hello-world latest '' '' '' 0 `
# ccr.ccs.tencentyun.com
# https://ccr.ccs.tencentyun.com/service/token token-service

# rootfs khs1994/hello-world latest '' '' '' 0 `
# registry.cn-hangzhou.aliyuncs.com
