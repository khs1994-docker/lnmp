Import-Module $PSScriptRoot/../../log/log.psm1 -force
Import-Module $PSScriptRoot/../cache/cache.psm1 -force

# "https://auth.docker.io/token"
# "registry.docker.io"

Function Get-TokenServerAndService([string]$registry = 'registry.hub.docker.com') {
  if ($registry -eq 'docker.io') {
    $registry = 'registry.hub.docker.com'
  }

  if ($env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER) {
    try {
      $token_server_and_service = ConvertFrom-Json $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER
      $cache = $token_server_and_service.$registry
    }
    catch {
      write-host $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER
      $env:DOCKER_ROOTFS_REGISTRY_TOKEN_SERVER = $null
    }

    if ($cache) {
      # write-host "==> Get registry token server and service from cache" -ForegroundColor Yellow
      # write-host $cache -ForegroundColor Green

      return $cache.server, $cache.service
    }
  }

  try {
    $WWW_Authenticate = (Invoke-WebRequest https://$registry/v2/ `
        -Method Get -MaximumRedirection 0 -UserAgent "Docker-Client/20.10.0 (Windows)" `
    ).Headers['WWW-Authenticate']
  }
  catch {
    $headers = $_.Exception.Response.Headers
    if ($headers.contains('WWW-Authenticate')) {
      $headers = $headers.toString().replace(': ', '=')

      $WWW_Authenticate = (ConvertFrom-StringData $headers)['WWW-Authenticate']
    }
  }

  $tokenServer = ''
  $tokenService = ''

  # Www-Authenticate	Bearer realm="https://auth.docker.io/token",service="registry.docker.io"
  if ($WWW_Authenticate) {
    foreach ($item in $WWW_Authenticate.split(',')) {
      $type, $value = $item.split('=', 2)
      $value = $value.replace('"', '')

      if ($type -eq 'Bearer realm') {
        $tokenServer = $value
        continue
      }

      if ($type -eq 'service') {
        $tokenService = $value
        continue
      }
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

function Get-DockerRegistryToken([string]$image,
  [string]$action = "pull",
  [string]$registry = 'registry.hub.docker.com',
  [boolean]$cache = $false) {

  $tokenServer, $tokenService = Get-TokenServerAndService $registry

  if (!($tokenServer)) {
    # write-host "==> tokenServer and tokenService not set, this registry maybe not need token" -ForegroundColor Yellow

    return 'token'
  }

  New-Item -force -type Directory (Get-CachePath token) | out-null

  $token_file = Get-CachePath "token/$($image.replace('/','@'))@${action}@$($tokenService.replace(':','-'))"

  if(!$env:DOCKER_TOKEN_EXPIRE_TIME){
    $env:DOCKER_TOKEN_EXPIRE_TIME=205
  }

  if (Test-Path $token_file) {
    $file_timestrap = (((Get-ChildItem $token_file).LastWriteTime.ToUniversalTime().Ticks - 621355968000000000) / 10000000).tostring().Substring(0, 10)
    $now_timestrap = (([DateTime]::Now.ToUniversalTime().Ticks - 621355968000000000) / 10000000).tostring().Substring(0, 10)
    if (($now_timestrap - $file_timestrap) -lt $env:DOCKER_TOKEN_EXPIRE_TIME) {
      # write-host "==> Token file cache find, not expire, use it" -ForegroundColor Green

      return (Get-Content $token_file -raw -Encoding utf8).trim()
    }
    else {
      # write-host "==> Token file cache find, but expire" -ForegroundColor Yellow
    }
  }
  else {
    # write-host "==> Token file cache not find" -ForegroundColor Green
  }

  # Write-Host "==> Token File is $token_file" -ForegroundColor Green

  if (!$env:DOCKER_USERNAME) {
    Write-Warning "ENV var DOCKER_USERNAME not set"
  }
  else {
    $DOCKER_USERNAME = $env:DOCKER_USERNAME
  }

  if (!$env:DOCKER_PASSWORD) {
    Write-Warning "ENV var DOCKER_PASSWORD not set"
  }
  else {
    $DOCKER_PASSWORD = $env:DOCKER_PASSWORD
  }

  $DOCKER_USERNAME = $env:DOCKER_USERNAME
  $DOCKER_PASSWORD = $env:DOCKER_PASSWORD

  if ($DOCKER_USERNAME -and $DOCKER_PASSWORD) {
    $secpasswd = ConvertTo-SecureString $DOCKER_PASSWORD -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($DOCKER_USERNAME, $secpasswd)
  }

  # $credential=Get-Credential

  try {
    $tokenServer, $query = $tokenServer.split('?')
    if ($query) {
      $query = "&$query"
    }
    if ($credential) {
      $result = Invoke-WebRequest -Authentication Basic -credential $credential `
        "${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}${query}" `
        -UserAgent "Docker-Client/20.10.1 (Windows)"
    }
    else {
      $result = Invoke-WebRequest `
        "${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}${query}" `
        -UserAgent "Docker-Client/20.10.1 (Windows)"
    }
  }
  catch {
    _error $_.InvocationInfo $_.Exception

    return $null
  }

  # write-host $result

  $token = (ConvertFrom-Json $result.Content).token

  if (!$token) {
    $token = (ConvertFrom-Json $result.Content).access_token
  }

  Set-Content $token_file $token

  return $token
}
