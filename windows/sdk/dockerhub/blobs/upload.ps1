Function upload($token, $image, $file, $contentType = "application/octet-stream", $registry = "registry.hub.docker.com") {
  $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Method 'POST' `
    -Uri "https://$registry/v2/$opt/blobs/uploads/" `

  $uuid = $result.Headers.'Location'

  $sha256 = (certutil -hashfile $file SHA256).split()[4]
  $length = (ls $file).Length

  curl.exe `
    -H "Content-Length: $length" `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    -T $file `
    "$uuid&digest=sha256:$sha256"

  return $length,$sha256
}
