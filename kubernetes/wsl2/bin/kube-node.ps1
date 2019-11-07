. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

if ($args[0] -eq 'stop'){
  "==> stop kube-node ..."
  wsl -u root -- supervisorctl stop kube-node:

  exit
}

& $PSScriptRoot/wsl2host --write
& $PSScriptRoot/wsl2host-check

"==> check kube-server $KUBE_APISERVER"
curl.exe -k --cacert /opt/k8s2/certs/ca.pem $KUBE_APISERVER | out-null

if(!$?){
  Write-Warning "kube-server $KUBE_APISERVER can't connent, maybe not running"
  Write-Warning "Please up kube-server first!"

  exit
}

wsl -- bash -c "if ! [ -f /lib/modules/`$(uname -r)/modules.builtin ];then exit 1;fi"

if(!$?){
  Write-Warning "
==> MUST update your WSL2 kernel, please see wsl2/README.KERNEL.md

"

  exit 1
}

wsl -- sh -c "command -v runc > /dev/null 2>&1"

if(!$?){
  Write-Warning "==> WSL2 runc not found, please install docker-ce first on WSL2"

  exit 1
}

& $PSScriptRoot/supervisorctl g
& $PSScriptRoot/supervisorctl update
& $PSScriptRoot/../kubelet init

wsl -u root -- supervisorctl start kube-node:

Write-Warning "

==> EXEC: ( $ ./wsl2/bin/kubectl-get-csr ), then approve csr

==> if PV is NFS, please up NFS Server first
"
