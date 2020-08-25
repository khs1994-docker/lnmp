. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip = wsl -d wsl-k8s -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

$NODE_NAME = "wsl2"
# $KUBE_APISERVER='https://x.x.x.x:16443'
# $K8S_ROOT="/opt/k8s"
$K8S_WSL2_ROOT = wsl -d wsl-k8s -- wslpath "'$PSScriptRoot'"
$WINDOWS_HOME_ON_WSL2 = wsl -d wsl-k8s -- wslpath "'$HOME'"

(Get-Content $PSScriptRoot/conf/kubelet.config.yaml.temp) `
  -replace "##NODE_NAME##", $NODE_NAME `
  -replace "##NODE_IP##", $wsl_ip `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/kubelet.config.yaml

wsl -d wsl-k8s -u root -- bash -c "echo NODE_NAME=$NODE_NAME > ${K8S_ROOT}/.env"
wsl -d wsl-k8s -u root -- `
  bash -c "echo KUBE_APISERVER=$KUBE_APISERVER | tee -a ${K8S_ROOT}/.env > /dev/null"

$command = wsl -d wsl-k8s -u root -- echo ${K8S_ROOT}/bin/kubelet `
  --bootstrap-kubeconfig=${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig `
  --cert-dir=${K8S_ROOT}/certs `
  --container-runtime=remote `
  --container-runtime-endpoint=unix:///run/kube-containerd/containerd.sock `
  --root-dir=/var/lib/kubelet `
  --kubeconfig=${K8S_ROOT}/conf/kubelet.kubeconfig `
  --config=${K8S_WSL2_ROOT}/conf/kubelet.config.yaml `
  --hostname-override=${NODE_NAME} `
  --volume-plugin-dir=${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ `
  --logtostderr=true `
  --dynamic-config-dir=${K8S_ROOT}/var/lib/kubelet/dynamic-config `
  --v=2

Function _reset() {
  wsl -d wsl-k8s -u root -- rm -rf ${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig
  wsl -d wsl-k8s -u root -- rm -rf ${K8S_ROOT}/conf/kubelet.kubeconfig
  wsl -d wsl-k8s -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-*
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
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log/kubelet-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log/kubelet-error.log
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

wsl -d wsl-k8s -u root -- ${K8S_ROOT}/bin/kubeadm version
wsl -d wsl-k8s -u root -- ls ${K8S_ROOT}/bin/generate-kubelet-bootstrap-kubeconfig.sh

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
  wsl -d wsl-k8s -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-server-*.pem
  # _reset
}

sleep 2

# wsl -d wsl-k8s -u root -- /usr/sbin/swapoff -a
# wsl -d wsl-k8s -u root -- /sbin/swapoff -a
wsl -d wsl-k8s -u root -- ${K8S_ROOT}/bin/generate-kubelet-bootstrap-kubeconfig.sh ${K8S_ROOT}
wsl -d wsl-k8s -u root -- mkdir -p ${K8S_ROOT}/var/lib/kubelet

if ($args[0] -eq 'init') {
  "==> kubelet init success !"
  exit
}

sleep 5

Function _mountKubelet($source, $dest) {
  wsl -d wsl-k8s -u root -- bash -c "mountpoint -q $dest"
  if (!$?) {
    wsl -d wsl-k8s -u root -- bash -c "mkdir -p $source $dest"
    Write-Warning "try mount $source to $dest ..."
    wsl -d wsl-k8s -u root -- bash -c "mount --bind $source $dest"
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

}

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  & $PSScriptRoot/bin/wsl2host-check
  _mountKubelet_all
  wsl -d wsl-k8s -u root -- supervisorctl start kube-node:kubelet

  exit
}

if ($args[0] -eq 'start') {
  & $PSScriptRoot/bin/wsl2host-check
  _mountKubelet_all
  wsl -d wsl-k8s -u root -- bash -c $command
}
