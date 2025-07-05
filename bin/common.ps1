. "$PSScriptRoot/../.env.example.ps1"

$_, $LNMP_ENV_FILE_PS1 = $(& $PSScriptRoot/../lnmp-docker.ps1 env-file)

if (Test-Path "$PSScriptRoot/../$LNMP_ENV_FILE_PS1") {
  . "$PSScriptRoot/../$LNMP_ENV_FILE_PS1"
}

# wsl -u root -- mountpoint -q /c

# if(!$?){
#   Write-Warning "wsl mount is error"
# }

function wslpath($WIN_PATH) {
  wsl -u root -- wslpath "'$WIN_PATH'"
}

$LNMP_USER = "root:root"

if ($IsWindows -and $PWD.ProviderPath.StartsWith('\\wsl$\')) {
  $LNMP_USER = "1000:1000"
}

if ($IsWindows -eq $False) {
  $LNMP_USER = "$(id -u):$(id -g)"
}

function Get-Env($ENV_NAME, $ENV_FILE, $ENV_DEFAULT) {
  $ENV_CONTENT = (cat ${ENV_FILE} | select-string ^$ENV_NAME=)
  if ($ENV_CONTENT) {
    if ($ENV_CONTENT.Line.GetType().FullName -eq 'System.String') {
      return $ENV_CONTENT.Line.split('=')[-1]
    }
    else {
      return $ENV_CONTENT.Line[-1].split('=')[-1]
    }
  }

  return $ENV_DEFAULT
}
