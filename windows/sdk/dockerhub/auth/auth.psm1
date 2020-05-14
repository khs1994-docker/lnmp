Import-Module $PSScriptRoot/../../log/log.psm1 -force
Import-Module $PSScriptRoot/../cache/cache.psm1 -force

function Get-DockerRegistryToken($image,
                  $action="pull",
                  $tokenServer="https://auth.docker.io/token",
                  $tokenService="registry.docker.io",
                  $cache=$false){
  New-Item -force -type Directory (Get-CachePath token) | out-null

  $token_file=Get-CachePath "token/$($image.replace('/','@'))@${action}@$($tokenService.replace(':','-'))"

  if (Test-Path $token_file) {
    $file_timestrap = (((Get-ChildItem $token_file).LastWriteTime.ToUniversalTime().Ticks - 621355968000000000)/10000000).tostring().Substring(0, 10)
    $now_timestrap = (([DateTime]::Now.ToUniversalTime().Ticks - 621355968000000000)/10000000).tostring().Substring(0, 10)
    if (($now_timestrap - $file_timestrap) -lt 249) {
      write-host "==> Token file cache find, not expire, use it" -ForegroundColor Green

      return (Get-Content $token_file -raw -Encoding utf8).trim()
    }else{
      write-host "==> Token file cache find, but expire" -ForegroundColor Yellow
    }
  }else{
    write-host "==> Token file cache not find" -ForegroundColor Green
  }

  Write-Host "==> Token File is $token_file" -ForegroundColor Green

if(!$env:DOCKER_USERNAME){
  Write-Warning "ENV var DOCKER_USERNAME not set"
}else{
  $DOCKER_USERNAME=$env:DOCKER_USERNAME
}

if(!$env:DOCKER_PASSWORD){
  Write-Warning "ENV var DOCKER_PASSWORD not set"
}else{
  $DOCKER_PASSWORD=$env:DOCKER_PASSWORD
}

$DOCKER_USERNAME = $env:DOCKER_USERNAME
$DOCKER_PASSWORD = $env:DOCKER_PASSWORD

if($DOCKER_USERNAME -and $DOCKER_PASSWORD){
  $secpasswd = ConvertTo-SecureString $DOCKER_PASSWORD -AsPlainText -Force
  $credential = New-Object System.Management.Automation.PSCredential($DOCKER_USERNAME, $secpasswd)
}

# $credential=Get-Credential

try{
  if($credential){
    $result = Invoke-WebRequest -Authentication Basic -credential $credential `
    "${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}" `
    -UserAgent "Docker-Client/19.03.5 (Windows)"
  }else{
    $result = Invoke-WebRequest `
    "${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}" `
    -UserAgent "Docker-Client/19.03.5 (Windows)"
  }
}catch{
  _error $_.InvocationInfo $_.Exception

  return $null
}

$token = (ConvertFrom-Json $result.Content).token

if(!$token){
  $token = (ConvertFrom-Json $result.Content).access_token
}

Set-Content $token_file $token

return $token
}
