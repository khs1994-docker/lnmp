. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

"==> check kube-server $KUBE_APISERVER"
curl.exe -k --cacert /opt/k8s2/certs/ca.pem $KUBE_APISERVER

if(!$?){
  Write-Warning "kube-server $KUBE_APISERVER can't connent, maybe not running"
  Write-Warning "Please up kube-server first!"

  exit
}

& $PSScriptRoot/supervisorctl g
& $PSScriptRoot/supervisorctl update
& $PSScriptRoot/../kubelet init

wsl -u root -- supervisorctl start kube-node:
