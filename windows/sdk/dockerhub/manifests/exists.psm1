Function Test-Manifest([string]$token, [string]$image, [string]$sha256, [string]$contentType = "application/vnd.docker.distribution.manifest.v2+json", [string]$registry = "registry.hub.docker.com") {
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
    write-host "==> check manifest exists error [ $($_.Exception.Response.StatusCode) ]" `
      -ForegroundColor Red

    if ($_.Exception.Response.StatusCode -eq 401) {
      throw '401'
    }

    return $false
  }

  return $true
}

Export-ModuleMember -Function Test-Manifest
