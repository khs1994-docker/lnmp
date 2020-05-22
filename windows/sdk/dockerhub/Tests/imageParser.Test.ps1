Import-Module $PSScriptRoot/../imageParser

$env:DEST_DOCKER_REGISTRY="docker.dest"

$sync_json = ConvertFrom-Json $(Get-Content $PSScriptRoot/../../../tests/docker-image-sync-test.json -raw)

foreach($item in $sync_json){
  imageParser $item.source $true
  imageParser $item.dest $false
}
