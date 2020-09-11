$ErrorActionPreference = "stop"

& $PSScriptRoot/kube-check

if (!$?) {
  exit 1
}

if ($args[0] -eq 'stop') {
  write-host "==> stop kube-server ..." -ForegroundColor Red
  wsl -d wsl-k8s -u root -- supervisorctl stop kube-server:

  exit
}

Import-Module $PSScriptRoot/WSL-K8S.psm1

Function _supervisor_checker() {
  write-host "==> check WSL dist [ wsl-k8s ] Supervisord running ..." -ForegroundColor Green
  wsl -d wsl-k8s -- sh -c "supervisorctl -h> /dev/null 2>&1"
  if (!$?) {
    write-warning "==> WSL dist [ wsl-k8s ] supervisor not installed, please install first"

    exit 1
  }
  wsl -d wsl-k8s -u root -- bash -ec "supervisorctl pid" > $null 2>&1

  if (!$?) {
    Write-Warning "WSL dist [ wsl-k8s ] Supervisord not running"
    write-host "==> try start WSL dist [ wsl-k8s ] Supervisord ..." -ForegroundColor Green
    Invoke-Supervisord
  }
}

Function _kube_nginx_checker() {
  write-host "==> check Windows kube-nginx running ..." -ForegroundColor Green
  if (!(Test-Path $HOME/.khs1994-docker-lnmp/wsl-k8s/kube-nginx/logs/nginx.pid)) {
    write-warning "Windows kube-nginx not running, exit"
    Write-Warning "please exec ( $ ./wsl2/kube-nginx ) first"
    exit 1
  }

  $kube_nginx_wsl2_ip = get-content $PSScriptRoot/../conf/.kube_nginx_wsl2_ip
  $wsl2_ip = & $PSScriptRoot/wsl2host.ps1

  if ($kube_nginx_wsl2_ip -ne $wsl2_ip) {
    Write-Warning "kube-nginx proxy $kube_nginx_wsl2_ip not eq current wsl2ip $wsl2_ip ,exit"
    Write-Warning "please exec ( $ ./wsl2/kube-nginx ) restart kube-nginx"

    exit
  }
}

Function _wsl2windows_proxy_checker() {
  write-host "==> check wsl2windows proxy ..." -ForegroundColor Green

  $wsl2windows_ip = ""

  if (Test-Path $PSScriptRoot/../conf/.wsl2windowsip) {
    $wsl2windows_ip = get-content $PSScriptRoot/../conf/.wsl2windowsip
  }
  $wsl2_ip = & $PSScriptRoot/wsl2host.ps1

  if ($wsl2windows_ip -ne $wsl2_ip) {
    Write-Warning "wsl2windows proxy wsl2ip [ $wsl2windows_ip ] not eq current wsl2ip [ $wsl2_ip ], exit"
    Write-Warning "please exec ( $ ./wsl2/kube-wsl2windows k8s ) reproxy"

    exit
  }
}

Function _etcd_checker() {
  write-host "==> check Windows Etcd running ..." -ForegroundColor Green
  try {
    & $PSScriptRoot/etcdctl.ps1 endpoint health
    # (get-process etcd).Id
  }
  catch {
    write-warning "Windows Etcd not running, exit"
    Write-Warning "please exec ( $ ./wsl2/etcd ) first"

    exit 1
  }
}

_supervisor_checker
# _kube_nginx_checker
_wsl2windows_proxy_checker
_etcd_checker

& $PSScriptRoot/wsl2host-check
& $PSScriptRoot/wsl2host --write
& $PSScriptRoot/supervisorctl g
& $PSScriptRoot/supervisorctl update

Invoke-WSL supervisorctl start kube-server:
