Import-Module $PSScriptRoot/../utils/Get-SHA.psm1
. $PSScriptRoot/../DockerImageSpec/DockerImageSpec.ps1

Function Test-Blob([string] $token, [string]$image, [string]$digest, [string]$registry = "registry.hub.docker.com") {
  try {
    Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Method 'HEAD' `
      -Uri "https://$registry/v2/$image/blobs/$digest" `
      -UserAgent "Docker-Client/20.10.1 (Windows)"

    write-host "==> Blob exists, skip upload" -ForegroundColor Yellow

    return $true
  }
  catch {
    write-host "==> Check blob exists error [ $($_.Exception.Response.StatusCode) ]" -ForegroundColor Yellow

    if ($_.Exception.Response.StatusCode -eq 401) {
      throw '401'
    }
  }

  return $false
}

Function New-Blob($token, $image, $file, $contentType = "application/octet-stream", $registry = "registry.hub.docker.com") {
  write-host "==> Blob type is $contentType" -ForegroundColor Blue

  $sha256 = Get-SHA256 $file
  $digest = "sha256:$sha256"

  write-host "==> Digest: $digest" -ForegroundColor Green

  # $sha512 = Get-SHA512 $file
  # $digest = "sha512:$sha512"

  $length = (Get-ChildItem $file).Length

  if (!($IsWindows)) { $env:TEMP = "/tmp" }

  if (Test-Blob $token $image $digest $registry) {
    #     write-host (ConvertFrom-Json -InputObject @"
    #     {
    #       "file": "$($file.replace('\','\\'))",
    #       "digest": "$digest"
    #     }
    # "@) -ForegroundColor Yellow

    return $length, $digest
  }

  write-host "==> Upload blob ..." -ForegroundColor Blue

  $result = Invoke-WebRequest `
    -Authentication OAuth `
    -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
    -Method 'POST' `
    -Uri "https://$registry/v2/$image/blobs/uploads/" `
    -UserAgent "Docker-Client/20.10.1 (Windows)"

  $uuid = $result.Headers.'Location'

  $length = (Get-ChildItem $file).Length

  $headers = @{}
  # $headers.Add('Content-Type', $contentType);
  $headers.Add('Content-Type', "application/octet-stream");
  $headers.Add('Authorization', "Bearer $token")

  if ($uuid.substring(0, 4) -eq '/v2/') {
    $uuid = "https://${registry}${uuid}"
  }

  try {
    $uri = "$uuid&digest=$digest"

    if (!("$uuid".Contains('?'))) {
      $uri = "${uuid}?digest=$digest"
    }

    $response = Invoke-WebRequest `
      -Uri $uri `
      -Headers $headers `
      -Method 'Put' `
      -Infile $file `
      -UserAgent "Docker-Client/20.10.1 (Windows)"

    $response_digest = $response.Headers.'Docker-Content-Digest'
  }
  catch {
    write-host $_.Exception
    write-host "==> Upload blob failed" -ForegroundColor Red

    return $false, $false
  }

  # $result = curl -k -L `
  #   -H "Content-Length: $length" `
  #   -H "Content-Type: $contentType" `
  #   -H "Authorization: Bearer $token" `
  #   -X PUT `
  #   --data-binary "@$file" `
  #   -A "Docker-Client/20.10.1 (Windows)" `
  #   -D $env:TEMP/curl_resp_header.txt `
  #   "$uuid&digest=$digest"

  # -T $file

  # $response_digest = ((Get-Content $env:TEMP/curl_resp_header.txt) | select-string 'Docker-Content-Digest').Line.split(' ')[-1]

  # write-host "==> exit code is $?" -ForegroundColor Green

  # write-host "==> Response header `n$(Get-Content $env:TEMP\curl_resp_header.txt -raw)" -ForegroundColor Green

  if ($response_digest -ne $digest) {
    write-host "==> Upload blob failed" -ForegroundColor Red
    return $false, $false
  }

  write-host "==> Upload blob success" -ForegroundColor Green

  #   write-host (ConvertFrom-Json -InputObject @"
  # {
  #   "file": "$($file.replace('\','\\'))",
  #   "digest": "$digest"
  # }
  # "@) -ForegroundColor Blue

  return $length, $digest
}

Export-ModuleMember -Function Test-Blob
Export-ModuleMember -Function New-Blob
