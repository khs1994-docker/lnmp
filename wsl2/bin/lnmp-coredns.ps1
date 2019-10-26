. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

Function _update_wsl2_host(){
  $wsl2host=& "$PSScriptRoot/../../kubernetes/wsl2/bin/wsl2host.ps1"

  etcdctl put /coredns/wsl2 $("{`"host`":`"$wsl2host`"}" | ConvertTo-Json)

  if (!$?){
    "
==> etcd not running, please start etcd first

$ .\kubernetes\wsl2\etcd

"

    exit 1
  }
}

_update_wsl2_host

mkdir -Force $HOME/.khs1994-docker-lnmp/coredns/ | out-null
$PIDFILE="$HOME/.khs1994-docker-lnmp/coredns/coredns.pid"

Function _start(){
if(Test-Path $PIDFILE){
  "==> coreDNS already running, pid is $(cat $PIDFILE)"
  get-process coredns

  exit 1
}

Start-Process -FilePath coredns `
  -ArgumentList "-conf","$PSScriptRoot\..\config\coredns\corefile","-pidfile",$PIDFILE `
-LoadUserProfile `
-RedirectStandardError "$HOME/.khs1994-docker-lnmp/coredns/error.log" `
-RedirectStandardOutput "$HOME/.khs1994-docker-lnmp/coredns/coredns.log" `
-WindowStyle Hidden

}
# $domains="com/khs1994/t/www"

foreach ($domain in $WSL2_DOMAINS){
  etcdctl put /coredns/$domain $('{"host":"wsl2"}' | ConvertTo-Json)
}

etcdctl put /coredns/internal/docker/wsl2 $('{"host":"wsl2"}' | ConvertTo-Json)

switch ($args[0]) {
  start {_start}

  stop {
    $ErrorActionPreference="SilentlyContinue"
    kill $(cat $PIDFILE)
    rm $PIDFILE
    sleep 2
    get-process coredns
  }

  log {
    code "$HOME/.khs1994-docker-lnmp/coredns/"
  }

  Default {
    echo "

COMMAND:

start start coredns
stop  stop coredns
log   cat coredns log
    "
  }
}
