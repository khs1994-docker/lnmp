. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

$NODE_NAME="wsl2"
# $KUBE_APISERVER='https://x.x.x.x:16443'
# $K8S_ROOT="/opt/k8s"
$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"
$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl pwd"

(Get-Content $PSScriptRoot/conf/kubelet.config.yaml.temp) `
    -replace "##NODE_NAME##",$NODE_NAME `
    -replace "##NODE_IP##",$wsl_ip `
    -replace "##K8S_ROOT##",$K8S_ROOT `
  | Set-Content $PSScriptRoot/conf/kubelet.config.yaml

wsl -u root -- bash -c "echo NODE_NAME=$NODE_NAME > ${K8S_ROOT}/.env"
wsl -u root -- `
  bash -c "echo KUBE_APISERVER=$KUBE_APISERVER | tee -a ${K8S_ROOT}/.env > /dev/null"

$command=wsl -u root -- echo ${K8S_ROOT}/bin/kubelet `
--bootstrap-kubeconfig=${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig `
--cert-dir=${K8S_ROOT}/certs `
--container-runtime=remote `
--container-runtime-endpoint=unix:///run/kube-containerd/containerd.sock `
--root-dir=${K8S_ROOT}/var/lib/kubelet `
--kubeconfig=${K8S_ROOT}/conf/kubelet.kubeconfig `
--config=${K8S_WSL2_ROOT}/conf/kubelet.config.yaml `
--hostname-override=${NODE_NAME} `
--volume-plugin-dir=${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ `
--logtostderr=true `
--dynamic-config-dir=${K8S_ROOT}/var/lib/kubelet/dynamic-config `
--experimental-check-node-capabilities-before-mount=true `
--v=2

Function _reset(){
  wsl -u root -- rm -rf ${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig
  wsl -u root -- rm -rf ${K8S_ROOT}/conf/kubelet.kubeconfig
  wsl -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-*
}

if($args[0] -eq "reset"){
  _reset

  exit
}

# --container-runtime=docker `
# --container-runtime-endpoint=unix:///var/run/dockershim.sock `
# --pod-infra-container-image=gcr.azk8s.cn/google-containers/pause:3.1 `
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

wsl -- sh -c "command -v runc > /dev/null 2>&1"

if(!$?){
  Write-Warning "==> runc not found, please install docker-ce first"

  exit 1
}

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kubelet]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kubelet-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kubelet-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kubelet.ini

if($args[0] -ne 'start' -and $args[0] -ne 'init'){
  exit
}

$env:ErrorActionPreference="stop"

wsl -u root -- ${K8S_ROOT}/bin/kubeadm version
wsl -u root -- ls ${K8S_ROOT}/bin/generate-kubelet-bootstrap-kubeconfig.sh

$env:ErrorActionPreference="continue"

if (Test-Path $PSScriptRoot/conf/.wsl_ip){
   $wsl_ip_from_file=cat $PSScriptRoot/conf/.wsl_ip

   if($wsl_ip -eq $wsl_ip_from_file){
      Write-Warning "wsl ip not changed"
   }else{
      Write-Warning "wsl ip changed, reset ..."
      echo $wsl_ip > $PSScriptRoot/conf/.wsl_ip
      wsl -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-server-*.pem
      # _reset
   }
}else{
   Write-Warning "wsl ip changed, reset ..."
   echo $wsl_ip > $PSScriptRoot/conf/.wsl_ip
   wsl -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-server-*.pem
   # _reset
}

sleep 2

# wsl -u root -- /usr/sbin/swapoff -a
# wsl -u root -- /sbin/swapoff -a
wsl -u root -- ${K8S_ROOT}/bin/generate-kubelet-bootstrap-kubeconfig.sh ${K8S_ROOT}
wsl -u root -- mkdir -p ${K8S_ROOT}/var/lib/kubelet

if($args[0] -eq 'init'){
  "==> kubelet init success !"
  exit
}

sleep 5

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- supervisorctl start kube-node:kubelet

  exit
}

if($args[0] -eq 'start'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- bash -c $command
}
