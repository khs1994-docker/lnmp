. "$PSScriptRoot/../.env.example.ps1"

$_,$LNMP_ENV_FILE_PS1=$(& $PSScriptRoot/../lnmp-docker.ps1 env-file)

if (Test-Path "$PSScriptRoot/../$LNMP_ENV_FILE_PS1"){
  . "$PSScriptRoot/../$LNMP_ENV_FILE_PS1"
}
