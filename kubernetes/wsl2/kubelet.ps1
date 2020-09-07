. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

$wsl_ip = Get-WSL2IP

$NODE_NAME = "wsl2"
# $KUBE_APISERVER='https://x.x.x.x:16443'
# $K8S_ROOT="/opt/k8s"
$WINDOWS_ROOT_IN_WSL2 = Invoke-WSL wslpath "'$PSScriptRoot'"
$WINDOWS_HOME_IN_WSL2 = Invoke-WSL wslpath "'$HOME'"
$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

(Get-Content $PSScriptRoot/conf/kubelet.config.yaml.temp) `
  -replace "##NODE_NAME##", $NODE_NAME `
  -replace "##NODE_IP##", $wsl_ip `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/kubelet.config.yaml

Invoke-WSL bash -c "echo NODE_NAME=$NODE_NAME > ${K8S_ROOT}/.env"
Invoke-WSL bash -c `
  "echo KUBE_APISERVER=$KUBE_APISERVER | tee -a ${K8S_ROOT}/.env > /dev/null"

$CONTAINER_RUNTIME_ENDPOINT = "unix:///run/kube-containerd/containerd.sock"

if ("$CRI" -eq 'cri-o') {
  $CONTAINER_RUNTIME_ENDPOINT = "unix:///var/run/crio/crio.sock"
}

$command = Invoke-WSL echo ${K8S_ROOT}/bin/kubelet `
  --bootstrap-kubeconfig=${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig `
  --cert-dir=${K8S_ROOT}/certs `
  --container-runtime=remote `
  --container-runtime-endpoint=$CONTAINER_RUNTIME_ENDPOINT `
  --root-dir=/var/lib/kubelet `
  --kubeconfig=${K8S_ROOT}/conf/kubelet.kubeconfig `
  --config=${WINDOWS_ROOT_IN_WSL2}/conf/kubelet.config.yaml `
  --hostname-override=${NODE_NAME} `
  --volume-plugin-dir=${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ `
  --logtostderr=true `
  --dynamic-config-dir=${K8S_ROOT}/var/lib/kubelet/dynamic-config `
  --v=2

Function _reset() {
  Invoke-WSL rm -rf ${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig
  Invoke-WSL rm -rf ${K8S_ROOT}/conf/kubelet.kubeconfig
  Invoke-WSL rm -rf ${K8S_ROOT}/certs/kubelet-*
}

if ($args[0] -eq "reset") {
  _reset

  exit
}

# --container-runtime=docker `
# --container-runtime-endpoint=unix:///var/run/dockershim.sock `
# --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2 `
# --image-pull-progress-deadline=15m `
# --network-plugin=cni `
# --cni-cache-dir=/opt/k8s/var/lib/cni/cache `
# --cni-bin-dir=/opt/k8s/opt/cni/bin `
# --cni-conf-dir=/opt/k8s/etc/cni/net.d `

# --container-runtime=remote `
# --container-runtime-endpoint=unix:///run/kube-containerd/containerd.sock `

#
# $ kubectl --kubeconfig .\rpi\certs\kubectl.kubeconfig get csr --sort-by='{.metadata.creationTimestamp}'
#

wsl -d wsl-k8s -- sh -c "command -v runc > /dev/null 2>&1"

if (!$?) {
  Write-Warning "==> runc not found, please install docker-ce first"

  exit 1
}

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kubelet]

command=$command
stdout_logfile=${SUPERVISOR_LOG_ROOT}/kubelet-stdout.log
stderr_logfile=${SUPERVISOR_LOG_ROOT}/kubelet-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kubelet.ini

if ($args[0] -ne 'start' -and $args[0] -ne 'init') {
  exit
}

$env:ErrorActionPreference = "stop"

Invoke-WSL ${K8S_ROOT}/bin/kubeadm version
Invoke-WSL ls ${K8S_ROOT}/bin/generate-kubelet-bootstrap-kubeconfig.sh

$env:ErrorActionPreference = "continue"

if (Test-Path $PSScriptRoot/conf/.wsl_ip) {
  $wsl_ip_from_file = cat $PSScriptRoot/conf/.wsl_ip

  if ($wsl_ip -eq $wsl_ip_from_file) {
    Write-Warning "wsl ip not changed"
  }
  else {
    Write-Warning "wsl ip changed, reset ..."
    echo $wsl_ip > $PSScriptRoot/conf/.wsl_ip
    wsl -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-server-*.pem
    # _reset
  }
}
else {
  Write-Warning "wsl ip changed, reset ..."
  echo $wsl_ip > $PSScriptRoot/conf/.wsl_ip
  Invoke-WSL rm -rf ${K8S_ROOT}/certs/kubelet-server-*.pem
  # _reset
}

sleep 2

# Invoke-WSL /usr/sbin/swapoff -a
# Invoke-WSL /sbin/swapoff -a
Invoke-WSL ${K8S_ROOT}/bin/generate-kubelet-bootstrap-kubeconfig.sh ${K8S_ROOT}
Invoke-WSL mkdir -p ${K8S_ROOT}/var/lib/kubelet

if ($args[0] -eq 'init') {
  "==> kubelet init success !"
  exit
}

sleep 5

Function _mountKubelet($source, $dest) {
  wsl -d wsl-k8s -u root -- bash -c "mountpoint -q $dest"
  if (!$?) {
    Invoke-WSL bash -c "mkdir -p $source $dest"
    Write-Warning "try mount $source to $dest ..."
    Invoke-WSL bash -c "mount --bind $source $dest"
  }
  else {
    Write-Warning "$dest already mount"
  }
}

function _mountKubelet_all() {
  _mountKubelet ${K8S_ROOT}/var/lib/kubelet /var/lib/kubelet
  _mountKubelet ${K8S_ROOT}/var/lib/khs1994-docker-lnmp /var/lib/khs1994-docker-lnmp
  _mountKubelet ${K8S_ROOT}/opt/cni/bin /opt/k8s/opt/cni/bin
  _mountKubelet ${K8S_ROOT}/etc/cni/net.d /opt/k8s/etc/cni/net.d
  _mountKubelet ${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins /opt/k8s/usr/libexec/kubernetes/kubelet-plugins
  _mountKubelet ${K8S_ROOT}/etc/containers /etc/containers
}

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  & $PSScriptRoot/bin/wsl2host-check
  _mountKubelet_all
  Invoke-WSL mount bpffs /sys/fs/bpf -t bpf
  Invoke-WSL supervisorctl start kube-node:kubelet

  exit
}

if ($args[0] -eq 'start') {
  & $PSScriptRoot/bin/wsl2host-check
  _mountKubelet_all
  Invoke-WSL mount bpffs /sys/fs/bpf -t bpf
  Invoke-WSL bash -c $command
}
