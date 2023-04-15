Import-Module $PSScriptRoot/../cache/cache.psm1
. $PSScriptRoot/../DockerImageSpec/DockerImageSpec.ps1
. $PSScriptRoot/../OCIImageSpec/OCIImageSpec.ps1

function Get-Manifest([string]$token, [string]$image, $ref, $header, $registry = "registry.hub.docker.com", $raw = $true, $return_digest_only = $false) {
  if (!$header) { $header = [DockerImageSpec]::manifest_list }

  $type = "manifest"

  if ($header -eq [DockerImageSpec]::manifest_list) { $type = "docker manifest list" }

  Write-host "==> Get [ $image $ref ] $type ..." -ForegroundColor Blue

  if (!($ref -is [string])) {
    $ref = $ref.toString()
  }

  New-Item -force -type Directory (get-CachePath manifests) | out-null
  $cache_file = Get-CachePath "manifests/$($ref.replace('sha256:','')).json"

  try {
    $result = Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Headers @{"Accept" = $header } `
      "https://$registry/v2/$image/manifests/$ref" `
      -PassThru `
      -OutFile $cache_file `
      -UserAgent "Docker-Client/20.10.16 (Windows)"
  }
  catch {
    $result = $_.Exception.Response

    Write-Host "==> [error] Get [ $image $ref ] $type error [ $($result.StatusCode) ]" -ForegroundColor Red

    if ($header -eq [DockerImageSpec]::manifest_list) {
      $header = [OCIImageSpec]::manifest_list
      $type = "oci manifest list"
    }

    if ($header -eq [DockerImageSpec]::manifest) {
      $header = [OCIImageSpec]::manifest
      $type = "oci manifest"
    }

    try {
      $result = Invoke-WebRequest `
        -Authentication OAuth `
        -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
        -Headers @{"Accept" = $header } `
        "https://$registry/v2/$image/manifests/$ref" `
        -PassThru `
        -OutFile $cache_file `
        -UserAgent "Docker-Client/20.10.16 (Windows)"
    }
    catch {
      $result = $_.Exception.Response

      Write-Host "==> [error] Get [ $image $ref ] $type error [ $($result.StatusCode) ]" -ForegroundColor Red

      return $false
    }
  }

  if ($result.Headers.'Content-Type' -ne $header) {
    Write-Host "==> [error] Get [ $image $ref ] $type error" -ForegroundColor Red

    return $false
  }

  write-host $result.Headers.'RateLimit-Limit'
  write-host $result.Headers.'RateLimit-Remaining'

  write-host "==> Digest: $($result.Headers.'Docker-Content-Digest')" -ForegroundColor Green

  if ($return_digest_only) {
    return $result.Headers.'Docker-Content-Digest'
  }

  if ($raw) {
    return ConvertFrom-Json (Get-Content $cache_file -Raw)
  }

  return $cache_file
}

Export-ModuleMember -Function Get-Manifest

# {
#   "mediaType": "application/vnd.docker.distribution.manifest.list.v2+json",
#   "schemaVersion": 2,
#   "manifests": [
#      {
#         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
#         "digest": "sha256:8ea052b0b8a58a5a56b21c19821f63175a4157a04639e99db80f17596e9f94ad",
#         "size": 2829,
#         "platform": {
#            "architecture": "amd64",
#            "os": "linux"
#         }
#      },
#      {
#         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
#         "digest": "sha256:c2d1e3774525083873b01c47b4cc06b0442db91cb8e0c9d90f8ce6df123da896",
#         "size": 2829,
#         "platform": {
#            "architecture": "arm64",
#            "os": "linux"
#         }
#      }
#   ]
# }
