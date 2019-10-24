wsl -u root -- service docker start

$ErrorActionPreference="continue"

& $PSScriptRoot/wsl2hostd.ps1 stop

& $PSScriptRoot/wsl2hostd.ps1 start
