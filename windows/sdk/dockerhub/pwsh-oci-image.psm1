Import-Module $PSScriptRoot/auth/auth.psm1
Import-Module $PSScriptRoot/blobs/upload.psm1
Import-Module $PSScriptRoot/manifests/upload.psm1
. $PSScriptRoot/OCIImageSpec/OCIImageSpec.ps1
. $PSScriptRoot/DockerImageSpec/DockerImageSpec.ps1

function New-Image() {
  [CmdletBinding()]
  Param(
    [parameter(mandatory = $true)][string][ValidateNotNullOrEmpty()]$image,
    [string]$ref = "latest",
    [string]$registry = 'registry.hub.docker.com'
  )

  $index = ConvertFrom-Json $(Get-Content index.json -raw)

  $manifests = $index.manifests

  foreach ($manifest in $manifests) {
    $manifest_digest = $manifest.digest

    if (!$manifest.platform) {
      write-host manifest platform miss -ForegroundColor Red

      return
    }

    $manifest_list_type = [DockerImageSpec]::manifest_list

    if ($manifest.mediaType -eq [OCIImageSpec]::manifest) {
      $manifest_list_type = [OCIImageSpec]::manifest_list
    }

    $manifest = ConvertFrom-Json $(Get-Content blobs/$($manifest.digest.replace(':', '/')) -raw)
    $layers = $manifest.layers
    $config = $manifest.config

    # push config
    write-host 1 push config blob $config.digest
    $file = $(Get-ChildItem blobs/$($config.digest.replace(':','/'))).FullName
    $token = Get-DockerRegistryToken $image 'push,pull' $registry
    New-Blob $token $image $file -registry $registry

    foreach ( $layer in $layers) {
      $digest = $layer.digest

      # push blob
      write-host 2 push blob $digest
      $file = $(Get-ChildItem blobs/$($digest.replace(':','/'))).FullName
      $token = Get-DockerRegistryToken $image 'push,pull' $registry
      New-Blob $token $image $file -registry $registry
    }

    # push manifest
    write-host 3 push manifest $manifest_digest
    $file = $(Get-ChildItem blobs/$($manifest_digest.replace(':','/'))).FullName
    $token = Get-DockerRegistryToken $image 'push,pull' $registry
    New-Manifest $token $image $manifest_digest $file $manifest.mediaType -registry $registry
  }

  # push index (manifest_list)
  if (!$index.mediaType) {
    $index = ConvertFrom-Json $(Get-Content index.json -raw) -AsHashtable
    write-host "==> index (manifest_list) miss mediaType, add $manifest_list_type" -ForegroundColor Green
    $index.mediaType = $manifest_list_type
    Set-Content index.json $(ConvertTo-Json $index -depth 10)
  }

  $file = $(Get-ChildItem index.json).FullName
  $token = Get-DockerRegistryToken $image 'push,pull' $registry
  New-Manifest $token $image $ref $file $manifest_list_type -registry $registry
}

#
# ├── blobs
# │   └── sha256
# │       ├── 4c4bdd6415430cff488dc116109e4203e1c28096b825976ffd0320617ece5d0f // manifest
# │       ├── 6446ea57df7b5badfcbdb47cf2d05d7831a33d36a97835b2c061cd1b4cc33deb // image config
# │       └── df20fa9351a15782c64e6dddb2d4a6f50bf6d3688060a34c4014b0d9a752eb4c // blob
# ├── index.json     // manifest_list
# ├── manifest.json
# └── oci-layout     // {"imageLayoutVersion":"1.0.0"}
