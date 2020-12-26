Import-Module $PSScriptRoot/../utils/Get-SHA.psm1
Import-Module $PSScriptRoot/../cache/cache.psm1

. $PSScriptRoot/../DockerImageSpec/DockerImageSpec.ps1

function Get-Dist($dist, $distTemp) {
  if ($dist) {
    copy-item -force $distTemp $dist

    return $dist
  }

  return $distTemp
}

function Test-SHA256($filename) {
  $sha256 = (Get-ChildItem $filename).name.split('.')[0]
  $current_sha256 = Get-SHA256 $filename

  if ($sha256 -ne $current_sha256 ) {
    Write-Host "==> $filename sha256 check failed" -ForegroundColor Red

    return $false
  }

  return $true
}

function Get-Blob([string]$token, [string]$image, [string]$digest, [string]$registry = "registry.hub.docker.com", $dist) {
  Write-Host "==> Digest: $digest" -ForegroundColor Green
  $sha256 = $digest.split(':')[1]
  $prefix = $sha256.Substring(0, 2)
  New-Item -force -type Directory (Get-CachePath blobs/sha256/$prefix) | out-null
  $distTemp = Get-CachePath "blobs/sha256/$prefix/$sha256"

  if (Test-Path $distTemp) {
    if (Test-SHA256 $distTemp) {
      Write-Host "==> File already exists, skip download" -ForegroundColor Green

      return Get-Dist $dist $distTemp
    }

    Write-Host "==> File already exists, but sha256 check failed, redownload" -ForegroundColor Red
  }

  try {
    $response = Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Headers @{"Accept" = [DockerImageSpec]::layer } `
      "https://$registry/v2/$image/blobs/$digest" `
      -PassThru `
      -OutFile $distTemp `
      -UserAgent "Docker-Client/20.10.1 (Windows)"
  }
  catch {
    $response = $_.Exception.Response

    $statusCode = $response.StatusCode

    if (!$statusCode) {
      Write-Host $_.Exception

      return $false
    }
    elseif ($statusCode -lt 400 -and $statusCode -gt 200) {
      $url = $response.Headers.Location

      # Write-Host "==> Redirect to $url" -ForegroundColor Magenta

      try {
        Invoke-WebRequest `
          "$url" `
          -PassThru `
          -OutFile $distTemp `
          -UserAgent "Docker-Client/20.10.1 (Windows)" > $null 2>&1
      }
      catch {
        Write-Host $_.Exception

        return $false
      }
    }
    else {
      Write-Host "==> Get blob failed [ $statusCode ]" -ForegroundColor Red

      return $false
    }
  }

  $size = (($response.RawContentLength) / 1024 / 1024)

  Write-Host "==> Download success, size is $('{0:n2}' -f $size) M" -ForegroundColor Green

  if (Test-SHA256 $distTemp) {
    return Get-Dist $dist $distTemp
  }

  return $false
}

Export-ModuleMember -Function Get-Blob
