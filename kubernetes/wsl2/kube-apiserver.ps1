. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

# wsl2
$wsl_ip = Get-WSL2IP

$KUBE_APISERVER_HOST = $wsl_ip
# wsl1
# $KUBE_APISERVER_HOST="x.x.x.x"

$WINDOWS_HOME_IN_WSL2 = Invoke-WSL wslpath "'$HOME'"
# $K8S_ROOT='/opt/k8s'

$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

$command = wsl -d wsl-k8s -u root -- echo ${K8S_ROOT}/bin/kube-apiserver `
  --advertise-address=${KUBE_APISERVER_HOST} `
  --default-not-ready-toleration-seconds=360 `
  --default-unreachable-toleration-seconds=360 `
  --max-mutating-requests-inflight=2000 `
  --max-requests-inflight=4000 `
  --default-watch-cache-size=200 `
  --delete-collection-workers=2 `
  --encryption-provider-config=${K8S_ROOT}/etc/kubernetes/encryption-config.yaml `
  --etcd-cafile=${K8S_ROOT}/etc/kubernetes/pki/etcd-ca.pem `
  --etcd-certfile=${K8S_ROOT}/etc/kubernetes/pki/apiserver-etcd-client.pem `
  --etcd-keyfile=${K8S_ROOT}/etc/kubernetes/pki/apiserver-etcd-client-key.pem `
  --etcd-servers=$K8S_ETCD_ENTRYPOINTS `
  --bind-address=${KUBE_APISERVER_HOST} `
  --secure-port=6443 `
  --tls-cert-file=${K8S_ROOT}/etc/kubernetes/pki/apiserver.pem `
  --tls-private-key-file=${K8S_ROOT}/etc/kubernetes/pki/apiserver-key.pem `
  --insecure-port=0 `
  --audit-log-maxage=15 `
  --audit-log-maxbackup=3 `
  --audit-log-maxsize=100 `
  --audit-log-truncate-enabled `
  --audit-log-path=${K8S_ROOT}/var/log/kubernetes/kube-apiserver/audit.log `
  --audit-policy-file=${K8S_ROOT}/etc/kubernetes/audit-policy.yaml `
  --profiling `
  --anonymous-auth=false `
  --client-ca-file=${K8S_ROOT}/etc/kubernetes/pki/ca.pem `
  --enable-bootstrap-token-auth `
  --requestheader-allowed-names="aggregator" `
  --requestheader-client-ca-file=${K8S_ROOT}/etc/kubernetes/pki/front-proxy-ca.pem `
  --requestheader-extra-headers-prefix="X-Remote-Extra-" `
  --requestheader-group-headers=X-Remote-Group `
  --requestheader-username-headers=X-Remote-User `
  --service-account-key-file=${K8S_ROOT}/etc/kubernetes/pki/sa.pub `
  --service-account-signing-key-file=${K8S_ROOT}/etc/kubernetes/pki/sa.key `
  --authorization-mode=Node,RBAC `
  --runtime-config=api/all=true `
  --enable-admission-plugins=NodeRestriction `
  --allow-privileged=true `
  --apiserver-count=1 `
  --event-ttl=168h `
  --kubelet-certificate-authority=${K8S_ROOT}/etc/kubernetes/pki/ca.pem `
  --kubelet-client-certificate=${K8S_ROOT}/etc/kubernetes/pki/apiserver-kubelet-client.pem `
  --kubelet-client-key=${K8S_ROOT}/etc/kubernetes/pki/apiserver-kubelet-client-key.pem `
  --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname `
  --kubelet-https=true `
  --kubelet-timeout=10s `
  --proxy-client-cert-file=${K8S_ROOT}/etc/kubernetes/pki/front-proxy-client.pem `
  --proxy-client-key-file=${K8S_ROOT}/etc/kubernetes/pki/front-proxy-client-key.pem `
  --service-cluster-ip-range=10.254.0.0/16,fd00::/108 `
  --service-node-port-range="1-65535" `
  --logtostderr=true `
  --service-account-issuer=api `
  --api-audiences=api `
  --feature-gates="IPv6DualStack=true,EphemeralContainers=true,GenericEphemeralVolume=true" `
  --v=2

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-apiserver]

command=$command
stdout_logfile=${SUPERVISOR_LOG_ROOT}/kube-apiserver-stdout.log
stderr_logfile=${SUPERVISOR_LOG_ROOT}/kube-apiserver-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-apiserver.ini

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  & $PSScriptRoot/bin/wsl2host-check
  Invoke-WSL supervisorctl start kube-server:kube-apiserver

  exit
}

if ($args[0] -eq 'start') {
  & $PSScriptRoot/bin/wsl2host-check
  Invoke-WSL bash -c $command
}
