Function Get-TokenServerAndService([string]$registry) {
  try {
    $WWW_Authenticate = (Invoke-WebRequest https://$registry/v2/x/y/manifests/latest `
        -Method Head -MaximumRedirection 0 -UserAgent "Docker-Client/19.03.5 (Windows)" `
    ).Headers['WWW-Authenticate']
  }
  catch {
    $headers = $_.Exception.Response.Headers
    # write-host $headers
    if ($headers.contains('WWW-Authenticate')) {
      # write-host (($headers.toString())[0])
      $WWW_Authenticate = $headers['WWW-Authenticate']

      if (!$WWW_Authenticate) {
        $headers = $headers.toString().replace(': ', '=')

        $WWW_Authenticate = (ConvertFrom-StringData $headers)['WWW-Authenticate']
      }
    }
  }

  if ($WWW_Authenticate) {
    # Bearer realm="https://auth.docker.io/token",service="registry.docker.io",scope="repository:x/y:pull"
    $result = $WWW_Authenticate.split(',').split('=')

    if ($result[0] -eq 'Bearer realm') {
      $tokenServer = $result[1].replace('"', '')
    }

    if ($result[2] -eq 'service') {
      $tokenService = $result[3].replace('"', '')
    }
  }

  return $tokenServer, $tokenService
}
