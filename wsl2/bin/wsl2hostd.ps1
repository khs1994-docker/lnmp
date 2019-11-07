<#
.SYNOPSIS
  Watch wsl2 ip changed, and write hosts to system
.DESCRIPTION
  Watch wsl2 ip changed, and write hosts to system
.EXAMPLE
  PS C:\> ./wsl2/bin/wsl2hostd.ps1
.INPUTS

.OUTPUTS

.NOTES

#>

mkdir -Force "$HOME/.khs1994-docker-lnmp/wsl2host" | out-null

$PIDFILE="$HOME/.khs1994-docker-lnmp/wsl2host/wsl2host.pid"

function _start(){
  if(Test-Path $PIDFILE){
    "==> wsl2host already watch, pid is $(cat $PIDFILE)"
    get-process powershell

    exit 1
  }

  Start-Process -FilePath "powershell" `
-ArgumentList "-c","& $PSScriptRoot/wsl2hostd.ps1 watch | out-null" `
-WindowStyle Hidden `
-LoadUserProfile `
-RedirectStandardOutput "$HOME/.khs1994-docker-lnmp/wsl2host/wsl2host.log" `
-RedirectStandardError "$HOME/.khs1994-docker-lnmp/wsl2host/error.log"

}

Function _watch(){
  echo $PID > $PIDFILE

  while($true){
    & $PSScriptRoot/../../kubernetes/wsl2/bin/wsl2host --write
    sleep 10
  }
}

switch ($args[0]) {
  start {_start}

  stop {
    $ErrorActionPreference="SilentlyContinue"
    kill $(cat $PIDFILE)
    rm $PIDFILE
    sleep 2
    get-process powershell
  }

  watch {_watch}
  Default {
    "
COMMAND:

start  start-process daemon
stop   stop watch wsl2 ip changed
watch  watch wsl2 ip changed

    "
  }
}
