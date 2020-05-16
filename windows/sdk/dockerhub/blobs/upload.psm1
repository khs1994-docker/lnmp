Import-Module $PSScriptRoot/../utils/sha256.psm1

# application/vnd.docker.container.image.v1+json

Function Test-Blob([string] $token, $image, $sha256, $registry = "registry.hub.docker.com") {
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

    if ($_.Exception.Response.StatusCode -eq 401) {
      throw '401'
    }
  }

  return $false
}

Function New-Blob($token, $image, $file, $contentType = "application/octet-stream", $registry = "registry.hub.docker.com") {
  write-host "==> Blob type is $contentType" -ForegroundColor Green

  $sha256 = sha256 $file
  $length = (Get-ChildItem $file).Length

  if (!($IsWindows)) { $env:TEMP = "/tmp" }

  if (Test-Blob $token $image $sha256 $registry) {
    write-host (ConvertFrom-Json -InputObject @"
    {
      "file": "$($file.replace('\','\\'))",
      "digest": "sha256:$sha256"
    }
"@) -ForegroundColor Yellow

    return $length, $sha256
  }

  write-host "==> Upload blob ..." -ForegroundColor Blue

  $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Method 'POST' `
    -Uri "https://$registry/v2/$image/blobs/uploads/" `
    -UserAgent "Docker-Client/19.03.5 (Windows)"

  $uuid = $result.Headers.'Location'

  $length = (Get-ChildItem $file).Length

  $result = curl -k -L `
    -H "Content-Length: $length" `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    -T $file `
    -A "Docker-Client/19.03.5 (Windows)" `
    -D $env:TEMP/curl_resp_header.txt `
    "$uuid&digest=sha256:$sha256"

  if (!($result)) {
    write-host "==> Blob upload success" -ForegroundColor Green

    write-host (ConvertFrom-Json -InputObject @"
{
  "file": "$($file.replace('\','\\'))",
  "digest": "sha256:$sha256"
}
"@) -ForegroundColor Blue
  }

  write-host "==> Response header `n$(Get-Content $env:TEMP\curl_resp_header.txt -raw)" -ForegroundColor Blue

  return $length, $sha256
}

Export-ModuleMember -Function Test-Blob
Export-ModuleMember -Function New-Blob
