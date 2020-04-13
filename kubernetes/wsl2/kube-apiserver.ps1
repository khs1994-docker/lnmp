. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

# wsl2
$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

$KUBE_APISERVER_HOST=$wsl_ip
# wsl1
# $KUBE_APISERVER_HOST="x.x.x.x"

$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl -d wsl-k8s pwd"

# $K8S_ROOT='/opt/k8s'

$command=wsl -d wsl-k8s -u root -- echo ${K8S_ROOT}/bin/kube-apiserver `
--advertise-address=${KUBE_APISERVER_HOST} `
--default-not-ready-toleration-seconds=360 `
--default-unreachable-toleration-seconds=360 `
--feature-gates=DynamicAuditing=true `
--max-mutating-requests-inflight=2000 `
--max-requests-inflight=4000 `
--default-watch-cache-size=200 `
--delete-collection-workers=2 `
--encryption-provider-config=${K8S_ROOT}/conf/encryption-config.yaml `
--etcd-cafile=${K8S_ROOT}/certs/ca.pem `
--etcd-certfile=${K8S_ROOT}/certs/apiserver-etcd-client.pem `
--etcd-keyfile=${K8S_ROOT}/certs/apiserver-etcd-client-key.pem `
--etcd-servers=$K8S_ETCD_ENTRYPOINTS `
--bind-address=${KUBE_APISERVER_HOST} `
--secure-port=6443 `
--tls-cert-file=${K8S_ROOT}/certs/apiserver.pem `
--tls-private-key-file=${K8S_ROOT}/certs/apiserver-key.pem `
--insecure-port=0 `
--audit-dynamic-configuration `
--audit-log-maxage=15 `
--audit-log-maxbackup=3 `
--audit-log-maxsize=100 `
--audit-log-truncate-enabled `
--audit-log-path=${K8S_ROOT}/var/log/kubernetes/kube-apiserver/audit.log `
--audit-policy-file=${K8S_ROOT}/conf/audit-policy.yaml `
--profiling `
--anonymous-auth=false `
--client-ca-file=${K8S_ROOT}/certs/ca.pem `
--enable-bootstrap-token-auth `
--requestheader-allowed-names="aggregator" `
--requestheader-client-ca-file=${K8S_ROOT}/certs/ca.pem `
--requestheader-extra-headers-prefix="X-Remote-Extra-" `
--requestheader-group-headers=X-Remote-Group `
--requestheader-username-headers=X-Remote-User `
--service-account-key-file=${K8S_ROOT}/certs/ca.pem `
--authorization-mode=Node,RBAC `
--runtime-config=api/all=true `
--enable-admission-plugins=NodeRestriction `
--allow-privileged=true `
--apiserver-count=1 `
--event-ttl=168h `
--kubelet-certificate-authority=${K8S_ROOT}/certs/ca.pem `
--kubelet-client-certificate=${K8S_ROOT}/certs/apiserver-kubelet-client.pem `
--kubelet-client-key=${K8S_ROOT}/certs/apiserver-kubelet-client-key.pem `
--kubelet-https=true `
--kubelet-timeout=10s `
--proxy-client-cert-file=${K8S_ROOT}/certs/proxy-client.pem `
--proxy-client-key-file=${K8S_ROOT}/certs/proxy-client-key.pem `
--service-cluster-ip-range=10.254.0.0/16 `
--service-node-port-range="1-65535" `
--logtostderr=true `
--v=2

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-apiserver]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log/kube-apiserver-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log/kube-apiserver-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-apiserver.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -d wsl-k8s -u root -- supervisorctl start kube-server:kube-apiserver

  exit
}

if($args[0] -eq 'start'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -d wsl-k8s -u root -- bash -c $command
}
