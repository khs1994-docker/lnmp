Function upload($token, $image, $ref, $manifest_json_path, $contentType = "application/vnd.docker.distribution.manifest.v2+json", $registry = "registry.hub.docker.com") {
  write-host "==> push [ $image $ref ] $contentType" -ForegroundColor Green

  curl.exe `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    -D $env:TEMP\curl_resp_header.txt `
    --data-binary "@$manifest_json_path" `
    -A "Docker-Client/19.03.5 (Windows)" `
    "https://$registry/v2/$image/manifests/$ref"

  write-host "==> resp header `n$(cat $env:TEMP\curl_resp_header.txt -raw)" -ForegroundColor Green

  $manifest_sha256=((cat $env:TEMP\curl_resp_header.txt) | select-string 'Docker-Content-Digest').Line.split('sha256:')[-1]

  write-host "==> $contentType push success, manifest is sha256:$manifest_sha256" -ForegroundColor Green

  $manifest_length= (ls $manifest_json_path).Length

  return $manifest_length,$manifest_sha256
}
