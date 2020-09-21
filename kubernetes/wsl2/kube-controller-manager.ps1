. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

$wsl_ip = Get-WSL2IP

$K8S_CM_HOST = $wsl_ip
# $K8S_ROOT='/opt/k8s'

$WINDOWS_HOME_IN_WSL2 = Invoke-WSL wslpath "'$HOME'"
$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

$command = wsl -d wsl-k8s -u root -- echo ${K8S_ROOT}/bin/kube-controller-manager `
  --profiling `
  --cluster-name=kubernetes `
  --controllers=*,bootstrapsigner,tokencleaner `
  --kube-api-qps=1000 `
  --kube-api-burst=2000 `
  --leader-elect `
  --use-service-account-credentials `
  --concurrent-service-syncs=2 `
  --bind-address=${K8S_CM_HOST} `
  --secure-port=10257 `
  --tls-cert-file=${K8S_ROOT}/etc/kubernetes/pki/kube-controller-manager.pem `
  --tls-private-key-file=${K8S_ROOT}/etc/kubernetes/pki/kube-controller-manager-key.pem `
  --port=0 `
  --authentication-kubeconfig=${K8S_ROOT}/etc/kubernetes/kube-controller-manager.kubeconfig `
  --client-ca-file=${K8S_ROOT}/etc/kubernetes/pki/ca.pem `
  --requestheader-allowed-names="" `
  --requestheader-client-ca-file=${K8S_ROOT}/etc/kubernetes/pki/front-proxy-ca.pem `
  --requestheader-extra-headers-prefix="X-Remote-Extra-" `
  --requestheader-group-headers=X-Remote-Group `
  --requestheader-username-headers=X-Remote-User `
  --authorization-kubeconfig=${K8S_ROOT}/etc/kubernetes/kube-controller-manager.kubeconfig `
  --cluster-signing-cert-file=${K8S_ROOT}/etc/kubernetes/pki/ca.pem `
  --cluster-signing-key-file=${K8S_ROOT}/etc/kubernetes/pki/ca-key.pem `
  --experimental-cluster-signing-duration=876000h `
  --horizontal-pod-autoscaler-sync-period=10s `
  --concurrent-deployment-syncs=10 `
  --concurrent-gc-syncs=30 `
  --service-cluster-ip-range=10.254.0.0/16,fd00::/108 `
  --pod-eviction-timeout=6m `
  --terminated-pod-gc-threshold=10000 `
  --root-ca-file=${K8S_ROOT}/etc/kubernetes/pki/ca.pem `
  --service-account-private-key-file=${K8S_ROOT}/etc/kubernetes/pki/sa.key `
  --kubeconfig=${K8S_ROOT}/etc/kubernetes/kube-controller-manager.kubeconfig `
  --logtostderr=true `
  --feature-gates="IPv6DualStack=true" `
  --v=2

# 可以调为 1h, 查看 kubelet 证书轮转
# --experimental-cluster-signing-duration=876000h `

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-controller-manager]

command=$command
stdout_logfile=${SUPERVISOR_LOG_ROOT}/kube-controller-manager-stdout.log
stderr_logfile=${SUPERVISOR_LOG_ROOT}/kube-controller-manager-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-controller-manager.ini

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  & $PSScriptRoot/bin/wsl2host-check
  Invoke-WSL supervisorctl start kube-server:kube-controller-manager

  exit
}

if ($args[0] -eq 'start') {
  & $PSScriptRoot/bin/wsl2host-check
  Invoke-WSL bash -c $command
}
