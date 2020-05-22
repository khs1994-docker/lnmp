Function New-Manifest([string]$token, [string]$image, [string]$ref, [string]$manifest_json_path, [string]$contentType = "application/vnd.docker.distribution.manifest.v2+json", [string]$registry = "registry.hub.docker.com") {
  write-host "==> push [ $image $ref ] $contentType" -ForegroundColor Green

  if (!($IsWindows)) { $env:TEMP = "/tmp" }

  curl -k -L `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    -D $env:TEMP/curl_resp_header.txt `
    --data-binary "@$manifest_json_path" `
    -A "Docker-Client/19.03.5 (Windows)" `
    "https://$registry/v2/$image/manifests/$ref"

  write-host "==> exit code is $?" -ForegroundColor Blue

  write-host "==> Response header `n$(Get-Content $env:TEMP/curl_resp_header.txt -raw)" -ForegroundColor Blue

  $manifest_digest = ((Get-Content $env:TEMP/curl_resp_header.txt) | select-string 'Docker-Content-Digest').Line.split(' ')[-1]

  write-host "==> $contentType push success, manifest is $manifest_digest" -ForegroundColor Green

  $manifest_length = (Get-ChildItem $manifest_json_path).Length

  return $manifest_length, $manifest_digest
}

Export-ModuleMember -Function New-Manifest
