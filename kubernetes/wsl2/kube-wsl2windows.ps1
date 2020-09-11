<#
.SYNOPSIS
  proxy wsl to windows
.DESCRIPTION
  proxy wsl to windows, replace 192.168.199.100 with your real windows ip

  ./kube-wsl2windows k8s

  ./kube-wsl2windows k8s-stop

  ./kube-wsl2windows stop 0.0.0.0:2049

  # kube-api-server

  ./kube-wsl2windows 6443 192.168.199.100:16443

  # nfs

  ./kube-wsl2windows 2049 192.168.199.100:2049

  # kube-scheduler

  ./kube-wsl2windows 10251 192.168.199.100:10251

  # kube-controller-manager

  ./kube-wsl2windows 10257 192.168.199.100:10257

  # kube-proxy

  ./kube-wsl2windows 10249 192.168.199.100:10249

.INPUTS

.OUTPUTS

.NOTES

#>

# https://github.com/MicrosoftDocs/WSL/blob/master/WSL/compare-versions.md#accessing-a-wsl-2-distribution-from-your-local-area-network-lan

function Start-wsl2windows($wsl, $windows) {
  $wsl2_port = $wsl
  $address, $port = $windows.split(':')

  write-host "==> start proxy $wsl2_port to ${address}:${port} ..." -ForegroundColor Green
  start-process -FilePath "netsh.exe" -ArgumentList "interface", "portproxy", "add", "v4tov4", `
    "listenport=$port", "listenaddress=$address", `
    "connectport=$wsl2_port", "connectaddress=${WSL2_HOST}" -Verb Runas
}

function Stop-wsl2windows($windows) {
  foreach ($item in $windows) {
    write-host "==> stop proxy $item ..." -ForegroundColor Red
    $address, $port = $item.split(':')

    start-process -FilePath "netsh.exe" -ArgumentList "interface", "portproxy", "delete", "v4tov4", `
      "listenport=$port", "listenaddress=$address" -Verb Runas
  }
}

if (!$IsWindows) {
  write-host "Only support Windows" -ForegroundColor Red

  return
}

. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1
& $PSScriptRoot/bin/wsl2d.ps1 wsl-k8s

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

$WSL2_HOST = Get-WSL2IP
$WINDOWS_HOST = "0.0.0.0"

if ($args[0] -eq 'k8s') {
  Start-wsl2windows 6443  ${WINDOWS_HOST}:16443
  Start-wsl2windows 10251 ${WINDOWS_HOST}:10251
  Start-wsl2windows 10257 ${WINDOWS_HOST}:10257
  Start-wsl2windows 10249 ${WINDOWS_HOST}:10249

  Start-wsl2windows 2049  ${WINDOWS_HOST}:2049

  Write-Output $WSL2_HOST > $PSScriptRoot/conf/.wsl2windowsip

  sleep 1
  netsh interface portproxy show all

  return
}

if ($args[0] -eq 'k8s-stop') {
  Stop-wsl2windows ${WINDOWS_HOST}:16443, `
    ${WINDOWS_HOST}:10251, `
    ${WINDOWS_HOST}:10257, `
    ${WINDOWS_HOST}:10249, `
    ${WINDOWS_HOST}:2049

  sleep 1
  netsh interface portproxy show all

  Remove-Item $PSScriptRoot/conf/.wsl2windowsip

  return
}

if ($args[0] -eq 'stop') {
  $_, $args = $args
  Stop-wsl2windows $args

  sleep 1
  netsh interface portproxy show all

  return
}

if ($args[0] -eq 'list') {
  netsh interface portproxy show all

  return
}

if ($args.Length -eq 0) {
  write-host "Get Help Info Please Exec $ ./kube-wsl2windows -?" -ForegroundColor Green
  return
}

Start-wsl2windows $args
