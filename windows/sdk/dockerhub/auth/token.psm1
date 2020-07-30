Function Get-TokenServerAndService([string]$registry) {
  if ($env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER) {
    try {
      $token_server_and_service = ConvertFrom-Json $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER
      $cache = $token_server_and_service.$registry
    }
    catch {
      $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER = $null
    }

    if ($cache) {
      # write-host "==> Get registry token server and service from cache" -ForegroundColor Yellow
      # write-host $cache -ForegroundColor Green

      return $cache.server, $cache.service
    }
  }
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

  if (!$env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER) {
    $DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER = ConvertFrom-Json '{}'
  }
  else {
    $DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER = ConvertFrom-Json $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER
  }

  $value = @{
    "server"  = $tokenServer;
    "service" = $tokenService;
  }

  $DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER | Add-Member -name $registry -value $value -MemberType NoteProperty -Force

  $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER = ConvertTo-Json $DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER

  return $tokenServer, $tokenService
}
