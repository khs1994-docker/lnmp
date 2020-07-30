Import-Module $PSScriptRoot/../utils/Get-SHA.psm1

Function Test-Blob([string] $token, [string]$image, [string]$digest, [string]$registry = "registry.hub.docker.com") {
  try {
    Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Method 'HEAD' `
      -Uri "https://$registry/v2/$image/blobs/$digest" `
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
  $file="C:\Users\90621/.khs1994-docker-lnmp/dockerhub/blobs/sha256/df/df20fa9351a15782c64e6dddb2d4a6f50bf6d3688060a34c4014b0d9a752eb4c"
  write-host "==> Blob type is $contentType" -ForegroundColor Green

  $sha256 = Get-SHA256 $file
  $digest = "sha256:$sha256"

  # $sha512 = Get-SHA512 $file
  # $digest = "sha512:$sha512"

  $length = (Get-ChildItem $file).Length

  if (!($IsWindows)) { $env:TEMP = "/tmp" }

  if (Test-Blob $token $image $digest $registry) {
    write-host (ConvertFrom-Json -InputObject @"
    {
      "file": "$($file.replace('\','\\'))",
      "digest": "$digest"
    }
"@) -ForegroundColor Yellow

    return $length, $digest
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

  # $result = curl -k -L `
  #   -H "Content-Length: $length" `
  #   -H "Content-Type: $contentType" `
  #   -H "Authorization: Bearer $token" `
  #   -X PUT `
  #   -T $file `
  #   -A "Docker-Client/19.03.5 (Windows)" `
  #   -D $env:TEMP/curl_resp_header.txt `
  #   "$uuid&digest=$digest"

try{
    # $file = Get-Item -Path $file
    $body=ConvertFrom-ByteArray -Data $([System.IO.File]::ReadAllBytes($file)) -Encoding ASCII
    $headers=@{}
    $headers.Add('Content-Length',$length)
    $headers.Add('Content-Type' ,$contentType)
    $headers.Add('Authorization',"Bearer $token")
    $result = Invoke-WebRequest `
      -Method 'Put' `
      -Uri "$uuid&digest=$digest" `
      -Headers $headers `
      -Body $body `
      -SkipHeaderValidation `
      -UserAgent "Docker-Client/19.03.5 (Windows)"
  #   $Params = @{
  #     Method          = 'Post'
  #     Uri             = "$Registry/v2/$Repository/blobs/uploads/"
  #     Headers         = @{}
  # }
  # write-host "$uuid&digest=$digest"
  # write-host $token
  #   $Params.Method = 'Put'
  #   $Params.Uri    = "$uuid&digest=$digest"
  #   $Params.Body   = $body
  #   $Params.Headers.Add('Authorization', "Bearer $token")
  #   $Params.Headers.Add('Content-Length', $body.Length)
  #   $Params.Headers.Add('Content-Type', $contentType)
  #   $result = Invoke-WebRequest @Params -SkipHeaderValidation
  }catch{
    write-host $_.Exception
  }
  # write-host $file
  # write-host New-DockerImageBlob -Repository $image -Data $body -Token $token -ContentType "application/octet-stream"
  write-host "==> exit code is $?" -ForegroundColor Blue

  if (!($result)) {
    write-host "==> Blob upload success" -ForegroundColor Green

    write-host (ConvertFrom-Json -InputObject @"
{
  "file": "$($file.replace('\','\\'))",
  "digest": "$digest"
}
"@) -ForegroundColor Blue
  }

  # write-host "==> Response header `n$(Get-Content $env:TEMP\curl_resp_header.txt -raw)" -ForegroundColor Green

  return $length, $digest
}

Export-ModuleMember -Function Test-Blob
Export-ModuleMember -Function New-Blob
