Import-Module $PSScriptRoot/../cache/cache.psm1
. $PSScriptRoot/../DockerImageSpec/DockerImageSpec.ps1
. $PSScriptRoot/../OCIImageSpec/OCIImageSpec.ps1

function Get-Manifest([string]$token, [string]$image, $ref, $header, $registry = "registry.hub.docker.com", $raw = $true, $return_digest_only = $false) {
  if (!$header) { $header = [DockerImageSpec]::manifest_list }

  $type = "docker manifest"

  if ($header -eq [DockerImageSpec]::manifest_list) { $type = "docker manifest list" }
  if ($header -eq [OCIImageSpec]::manifest_list) { $type = "oci manifest list" }
  if ($header -eq [OCIImageSpec]::manifest) { $type = "oci manifest" }

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

    Write-Host "==> [Info] Try [ $image $ref ] $type ..." -ForegroundColor Blue

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
    Write-Host "==> [error] Get [ $image $ref ] $type error, find [ $($result.Headers.'Content-Type') ]" -ForegroundColor Red

    return $false
  }

  if ($result.Headers.'RateLimit-Limit') {
    write-host $result.Headers.'RateLimit-Limit'
    write-host $result.Headers.'RateLimit-Remaining'
  }

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


# {
#    "schemaVersion": 2,
#    "mediaType": "application/vnd.oci.image.index.v1+json",
#    "manifests": [
#       {
#          "mediaType": "application/vnd.oci.image.manifest.v1+json",
#          "size": 1598,
#          "digest": "sha256:e39f6119f134b4811af19fd5c20f495a6a264a85c1b6920daf569b23009dd42c",
#          "platform": {
#             "architecture": "amd64",
#             "os": "linux"
#          }
#       },
#       {
#          "mediaType": "application/vnd.oci.image.manifest.v1+json",
#          "size": 1598,
#          "digest": "sha256:a090c17d367f2686633f2be8a10cb1670ed1c12bb47c6e47ea0dde84a8512765",
#          "platform": {
#             "architecture": "arm",
#             "os": "linux",
#             "variant": "v7"
#          }
#       }
#    ]
# }


# {
#   "schemaVersion": 2,
#   "mediaType": "application/vnd.oci.image.manifest.v1+json",
#   "config": {
#     "mediaType": "application/vnd.oci.image.config.v1+json",
#     "digest": "sha256:6e8aca117d2edaca3e07438f3130753c91d106f98ead008c1c7d1a5925d78dbf",
#     "size": 448,
#     "data": "eyJjb25maWciOnsiRW52IjpbIlBBVEg9L3Vzci9sb2NhbC9zYmluOi91c3IvbG9jYWwvYmluOi91c3Ivc2JpbjovdXNyL2Jpbjovc2JpbjovYmluIl0sIkVudHJ5cG9pbnQiOltdLCJDbWQiOlsiYmFzaCJdfSwiY3JlYXRlZCI6IjIwMjYtMTAtMDVUMDA6MDA6MDBaIiwiaGlzdG9yeSI6W3siY3JlYXRlZCI6IjIwMjYtMTAtMDVUMDA6MDA6MDBaIiwiY3JlYXRlZF9ieSI6IiMgZGViaWFuLnNoIC0tYXJjaCAnYW1kNjQnIG91dC8gJ3NpZCcgJ0AxNzkxMTU4NDAwJyIsImNvbW1lbnQiOiJkZWJ1ZXJyZW90eXBlIDAuMTcifV0sInJvb3RmcyI6eyJ0eXBlIjoibGF5ZXJzIiwiZGlmZl9pZHMiOlsic2hhMjU2Ojc2OGRiYjQyMzZkMGY5NjA4YWU5MTZmMzA2MzgwYzQ4ZDZlNmU4NDIzNjYzZTI3NjJjY2MwMjlkZTYyNzZiOWYiXX0sIm9zIjoibGludXgiLCJhcmNoaXRlY3R1cmUiOiJhbWQ2NCJ9Cg=="
#   },
#   "layers": [
#     {
#       "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip",
#       "digest": "sha256:3a86a893412c5e936c0cc39ada45b42d1af83b7c8cb3595a49c24aed89510eed",
#       "size": 30864442
#     }
#   ]
# }
