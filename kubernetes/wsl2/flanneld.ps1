. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

# $K8S_ROOT="/opt/k8s"
# $K8S_ETCD_ENTRYPOINTS="https://x.x.x.x:2379"

wsl -u root -- mkdir --parents /var/lib/coreos /run/flannel

$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl pwd"

$env:ETCDCTL_API=2

etcdctl `
  --endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --ca-file="$PSScriptRoot/certs/ca.pem" `
  --cert-file="$PSScriptRoot/certs/flanneld.pem" `
  --key-file="$PSScriptRoot/certs/flanneld-key.pem" `
  get /kubernetes/network/config

if (!($?)){
  Write-Warning "flanneld etcd config not found, config ..."

  etcdctl `
  --endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --ca-file="$PSScriptRoot/certs/ca.pem" `
  --cert-file="$PSScriptRoot/certs/flanneld.pem" `
  --key-file="$PSScriptRoot/certs/flanneld-key.pem" `
  set /kubernetes/network/config `
  $('{"Network":"172.30.0.0/16","SubnetLen":24,"Backend":{"Type":"vxlan"}}' | ConvertTo-Json)
}

$command=wsl -u root -- echo ${K8S_ROOT}/bin/flanneld `
  --etcd-endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --etcd-cafile="${K8S_ROOT}/certs/ca.pem" `
  --etcd-certfile="${K8S_ROOT}/certs/flanneld.pem" `
  --etcd-keyfile="${K8S_ROOT}/certs/flanneld-key.pem" `
  --etcd-prefix="/kubernetes/network" `
  --ip-masq

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:flanneld]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/flanneld-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/flanneld-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/flanneld.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- supervisorctl start kube-node:flanneld

  exit
}

if($args[0] -eq 'start'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- bash -c $command
}
