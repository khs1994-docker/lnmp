Import-Module $PSScriptRoot\..\dockerhub\imageParser\imageParser.psm1 -force

$env:DEST_REPLACE = ''
$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io/library"
$dest = 'A'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false $true

if ($dest_registry -eq 'ghcr.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'khs1994-docker/docker.io/library/A') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false $true

if ($dest_registry -eq 'ghcr.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'khs1994-docker/docker.io/A/B') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B/C'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false $true

if ($dest_registry -eq 'ghcr.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'khs1994-docker/docker.io/A/B/C') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false

if ($dest_registry -eq 'ghcr.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'A/B') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B/C'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false $true

if ($dest_registry -eq 'ghcr.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'khs1994-docker/docker.io/A/B/C') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $true

if ($dest_registry -eq 'registry-1.docker.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'library/A') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $true

if ($dest_registry -eq 'registry-1.docker.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'A/B') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B/C'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $true

if ($dest_registry -eq 'A') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'B/C') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B/C/D'

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $true

if ($dest_registry -eq 'A') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'B/C/D') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

##################################################

$env:DEST_DOCKER_REGISTRY = "ghcr.io"
$env:DEST_NAMESPACE = "khs1994-docker/docker.io"
$dest = 'A/B/C/D'
$env:DEST_REPLACE = $true

$dest_registry, $dest_image, $dest_ref, $dest_image_with_digest = imageParser $dest $false $true

if ($dest_registry -eq 'ghcr.io') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_image -eq 'khs1994-docker/docker.io/A-B-C-D') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}

if ($dest_ref -eq 'latest') {
  Write-Host -BackgroundColor Green 'PASS'
}
else {
  Write-Host -BackgroundColor Red 'FAIL'
}
