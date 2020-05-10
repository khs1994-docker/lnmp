Function _sha256($file){
  if($IsWindows){
    return (certutil -hashfile $file SHA256).split()[4]
  }

  return (sha256sum $file | cut -d ' ' -f 1)
}

function getDist($dist,$distTemp){
  if($dist){
    copy-item -force $distTemp $dist

    return $dist
  }

  return $distTemp
}

function _sha256_checker($filename) {
  $sha256 = (ls $filename).name.split('.')[0]
  $current_sha256 = _sha256 $filename

  if ($sha256 -ne $current_sha256 ) {
    Write-Host "==> $filename sha256 check failed" -ForegroundColor Red

    return $false
  }

  return $true
}

function get($token,$image,$digest,$registry="registry.hub.docker.com",$dist){
  . $PSScriptRoot/../cache/cache.ps1

  New-Item -force -type Directory (getCachePath blobs) | out-null
  $distTemp = getCachePath "blobs/$($digest.split(':')[1]).tar.gz"

  if (Test-Path $distTemp) {
    if (_sha256_checker $distTemp) {
      Write-Host "==> File already exists, skip download" -ForegroundColor Green

      return getDist $dist $distTemp
    }

    Write-Host "==> File already exists, but sha256 check failed, redownload" -ForegroundColor Red
  }

  try{
    $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Headers @{"Accept" = "application/vnd.docker.image.rootfs.diff.tar.gzip"} `
    "https://$registry/v2/$image/blobs/$digest" `
    -PassThru `
    -OutFile $distTemp `
    -UserAgent "Docker-Client/19.03.5 (Windows)"
  }catch{
    $result = $_.Exception.Response

    $statusCode = $result.StatusCode

    if(!$statusCode){
      Write-Host $_.Exception
    }

    # Write-Host $_.Exception
    Write-Host "==> HTTP StatusCode is $statusCode"

    if($statusCode -lt 400 -and $statusCode -gt 200){
      $url = $result.Headers.Location

      Write-Host "==> Redirect to $url"

      $result3xx = Invoke-WebRequest `
      "$url" `
      -PassThru `
      -OutFile $distTemp `
      -UserAgent "Docker-Client/19.03.5 (Windows)"
    }else{
      return $false
    }
  }

  $size = (($result.RawContentLength)/1024/1024)

  Write-Host "Download size is $('{0:n2}' -f $size) M" -ForegroundColor Green

  if (_sha256_checker $distTemp) {
    return getDist $dist $distTemp
  }

  return $false
}
