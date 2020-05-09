function getDist($dist,$distTemp){
  if($dist){
    copy-item -force $distTemp $dist

    return $dist
  }

  return $distTemp
}

function get($token,$image,$digest,$registry="registry.hub.docker.com",$dist){
  . $PSScriptRoot/../cache/cache.ps1

  New-Item -force -type Directory (getCachePath blobs) | out-null
  $distTemp = getCachePath "blobs/$($digest.split(':')[1]).tar.gz"

  if(Test-Path $distTemp){
    Write-Host "==> File already exists, skip download" -ForegroundColor Green

    return getDist $dist $distTemp
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

  return getDist $dist $distTemp
}
