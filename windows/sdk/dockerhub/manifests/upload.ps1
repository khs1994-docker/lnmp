Function upload($token, $image, $ref, $manifest_json_path, $contentType = "application/vnd.docker.distribution.manifest.v2+json", $registry = "registry.hub.docker.com") {
  curl.exe `
    -H "Content-Type: $contentType" `
    -H "Authorization: Bearer $token" `
    -X PUT `
    --data-binary "@$manifest_json_path" `
    "https://$registry/v2/$image/manifests/$ref"

  write-host "==> manifest push success" -ForegroundColor Green
}
