Function _sha256($file){
  if($IsWindows){
    return (certutil -hashfile $file SHA256).split()[4]
  }

  return (sha256sum $file | cut -d ' ' -f 1)
}

# application/vnd.docker.container.image.v1+json

Function _isExists([string] $token, $image, $sha256, $registry = "registry.hub.docker.com") {
  try {
    Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Method 'HEAD' `
      -Uri "https://$registry/v2/$image/blobs/sha256:$sha256" `
      -UserAgent "Docker-Client/19.03.5 (Windows)"

    write-host "==> Blob found, skip upload" -ForegroundColor Yellow

    return $true
  }
  catch {
    write-host "==> Check blob exists error" -ForegroundColor Yellow
    write-host $_.Exception

    if($_.Exception.Response.StatusCode -eq 401){
      throw '401'
    }
  }

  return $false
}

Function upload($token, $image, $file, $contentType = "application/octet-stream", $registry = "registry.hub.docker.com") {
  $sha256 = _sha256 $file
  $length = (ls $file).Length

  if(!($IsWindows)){ $env:TEMP="/tmp" }

  if(_isExists $token $image $sha256 $registry){
    write-host (ConvertFrom-Json -InputObject @"
    {
      "file": "$($file.replace('\','\\'))",
      "digest": "sha256:$sha256"
    }
"@) -ForegroundColor Yellow

     return $length,$sha256
  }

  write-host "==> Upload blob ..." -ForegroundColor Blue

  $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Method 'POST' `
    -Uri "https://$registry/v2/$image/blobs/uploads/" `
    -UserAgent "Docker-Client/19.03.5 (Windows)"

  $uuid = $result.Headers.'Location'

  $length = (ls $file).Length

  $result = curl -L `
    -H "Content-Length: $length" `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    -T $file `
    -A "Docker-Client/19.03.5 (Windows)" `
    -D $env:TEMP/curl_resp_header.txt `
    "$uuid&digest=sha256:$sha256"

  if(!($result)){
    write-host "==> Blob upload success" -ForegroundColor Green

    write-host (ConvertFrom-Json -InputObject @"
{
  "file": "$($file.replace('\','\\'))",
  "digest": "sha256:$sha256"
}
"@) -ForegroundColor Blue
  }

  write-host "==> Response header `n$(cat $env:TEMP\curl_resp_header.txt -raw)" -ForegroundColor Green

  return $length,$sha256
}
