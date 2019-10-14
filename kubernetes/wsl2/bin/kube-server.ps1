$ErrorActionPreference="stop"

if ($args[0] -eq 'stop'){
  "==> stop kube-server ..."
  wsl -u root -- supervisorctl stop kube-server:

  exit
}

Function _supervisor_checker(){
  "==> check WSL2 Supervisord running ..."
  wsl -u root -- bash -ec "supervisorctl pid" > $HOME/.k8s-wsl2/out-null 2>&1

  if(!$?){
    Write-Warning "WSL2 Supervisord not running"
    "==> try start WSL2 Supervisord ..."
    & $PSScriptRoot/supervisord.ps1
  }
}

Function _kube_nginx_checker(){
  "==> check Windows kube-nginx running ..."
  if (!(Test-Path $HOME/.k8s-wsl2/kube-nginx/logs/nginx.pid)){
    write-warning "Windows kube-nginx not running, exit"

    exit 1
  }

  $kube_nginx_wsl2_ip=get-content $PSScriptRoot/../conf/.kube_nginx_wsl2_ip
  $wsl2_ip=& $PSScriptRoot/wsl2host.ps1

  if ($kube_nginx_wsl2_ip -ne $wsl2_ip){
    Write-Warning "kube-nginx proxy wsl2ip $kube_nginx_wsl2_ip noteq $wsl2_ip"
  }
}

Function _etcd_checker(){
  "==> check Windows Etcd running ..."
  try{
    & $PSScriptRoot/etcdctlv2.ps1 cluster-health $HOME/.k8s-wsl2/out-null 2>&1
    # (get-process etcd).Id
  }catch{
    write-warning "Windows Etcd not running, exit"

    exit 1
  }
}

_kube_nginx_checker
_etcd_checker
_supervisor_checker

& $PSScriptRoot/supervisorctl g
& $PSScriptRoot/supervisorctl update

wsl -u root -- supervisorctl start kube-server:
