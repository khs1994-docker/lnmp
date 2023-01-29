#!/usr/bin/env pwsh

#Requires -Version 5.0.0

if($args[0] -eq 'install-service'){
  Write-Host "please use $ $PSScriptRoot/windows/lnmp-windows-pm.ps1" -ForegroundColor Red

  exit
}

pwsh -c "$PSScriptRoot/windows/lnmp-windows-pm.ps1 $args"

# install pwsh
# https://docs.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell?view=powershell-7
