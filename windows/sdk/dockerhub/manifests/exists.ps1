Function _is_exists($token, $image, $sha256, $contentType = "application/vnd.docker.distribution.manifest.v2+json", $registry = "registry.hub.docker.com") {
  try {
    Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Headers @{"Accept" = "$contentType" } `
      "https://$registry/v2/$image/manifests/$sha256" `
      -Method Head `
      -UserAgent "Docker-Client/19.03.5 (Windows)"
  }
  catch {
    write-host "==> check manifest exists error $($_.Exception.Response.StatusCode)" `
      -ForegroundColor Red

    return $false
  }

  return $true
}
