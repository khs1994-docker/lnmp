Function upload($token, $image, $file, $contentType = "application/octet-stream", $registry = "registry.hub.docker.com") {
  $sha256 = (certutil -hashfile $file SHA256).split()[4]
  $length = (ls $file).Length

  try{
  $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Method 'HEAD' `
    -Uri "https://$registry/v2/$opt/blobs/sha256:$sha256" `

  write-host "==> blob found, skip upload" -ForegroundColor Yellow

  write-host (ConvertFrom-Json -InputObject @"
{
  "file": "$($file.replace('\','\\'))",
  "digest": "sha256:$sha256"
}
"@) -ForegroundColor Blue

  return $length,$sha256
  }catch{}

  $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Method 'POST' `
    -Uri "https://$registry/v2/$opt/blobs/uploads/" `
    -UserAgent "Docker-Client/19.03.5 (Windows)"

  $uuid = $result.Headers.'Location'

  $length = (ls $file).Length

  $result = curl.exe `
    -H "Content-Length: $length" `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    -T $file `
    -A "Docker-Client/19.03.5 (Windows)" `
    -D $env:TEMP\curl_resp_header.txt `
    "$uuid&digest=sha256:$sha256"

  if(!($result)){
    write-host "==> blob upload success" -ForegroundColor Green

    write-host (ConvertFrom-Json -InputObject @"
{
  "file": "$($file.replace('\','\\'))",
  "digest": "sha256:$sha256"
}
"@) -ForegroundColor Blue
  }

  write-host "==> resp header `n$(cat $env:TEMP\curl_resp_header.txt -raw)" -ForegroundColor Green

  return $length,$sha256
}
