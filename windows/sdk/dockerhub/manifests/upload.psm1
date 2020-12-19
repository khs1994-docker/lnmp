Function New-Manifest([string]$token, [string]$image, [string]$ref, [string]$manifest_json_path, [string]$contentType = "application/vnd.docker.distribution.manifest.v2+json", [string]$registry = "registry.hub.docker.com") {
  write-host "==> push [ $image $ref ] $contentType" -ForegroundColor Blue

  # if (!($IsWindows)) { $env:TEMP = "/tmp" }

  # curl -k -L `
  #   -H "Content-Type: $contentType" `
  #   -H "Authorization: Bearer $token" `
  #   -X PUT `
  #   -D $env:TEMP/curl_resp_header.txt `
  #   --data-binary "@$manifest_json_path" `
  #   -A "Docker-Client/20.10.1 (Windows)" `
  #   "https://$registry/v2/$image/manifests/$ref"

  $headers = @{}
  $headers.Add('Content-Type', $contentType);
  $headers.Add('Authorization', "Bearer $token")

  try {
    $response = Invoke-WebRequest `
      -Uri "https://$registry/v2/$image/manifests/$ref" `
      -Headers $headers `
      -Method 'Put' `
      -Body $(Get-Content $manifest_json_path -raw) `
      -UserAgent "Docker-Client/20.10.1 (Windows)"
  }
  catch {
    write-host $_.Exception

    return $false, $false
  }

  # write-host "==> exit code is $?" -ForegroundColor Green

  # write-host "==> Response header `n$(Get-Content $env:TEMP/curl_resp_header.txt -raw)" -ForegroundColor Green

  # $manifest_digest = ((Get-Content $env:TEMP/curl_resp_header.txt) | select-string 'Docker-Content-Digest').Line.split(' ')[-1]

  $manifest_digest = $response.Headers.'Docker-Content-Digest'

  write-host "==> Digest: $manifest_digest" -ForegroundColor Green
  write-host "==> Push $contentType success" -ForegroundColor Green

  $manifest_length = (Get-ChildItem $manifest_json_path).Length

  return $manifest_length, $manifest_digest
}

Export-ModuleMember -Function New-Manifest
