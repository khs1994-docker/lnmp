. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

$NODE_NAME="wsl2"
$KUBE_APISERVER='https://192.168.199.100:16443'
# $K8S_ROOT="/opt/k8s"
$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

(Get-Content $PSScriptRoot/conf/kubelet-config.yaml.temp) `
    -replace "##NODE_NAME##",$NODE_NAME `
    -replace "##NODE_IP##",$wsl_ip `
  | Set-Content $PSScriptRoot/conf/kubelet-config.yaml

wsl -u root -- bash -c "echo NODE_NAME=$NODE_NAME > /opt/k8s/.env"
wsl -u root -- `
  bash -c "echo KUBE_APISERVER=$KUBE_APISERVER | tee -a /opt/k8s/.env"

$command=wsl -u root -- echo /opt/k8s/bin/kubelet `
--bootstrap-kubeconfig=${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig `
--cert-dir=${K8S_ROOT}/certs `
--container-runtime=remote `
--container-runtime-endpoint=unix:///run/kube-containerd/containerd.sock `
--root-dir=/var/lib/kubelet `
--kubeconfig=${K8S_ROOT}/conf/kubelet.kubeconfig `
--config=${K8S_WSL2_ROOT}/conf/kubelet-config.yaml `
--hostname-override=${NODE_NAME} `
--pod-infra-container-image=gcr.azk8s.cn/google-containers/pause:3.1 `
--image-pull-progress-deadline=15m `
--volume-plugin-dir=/var/lib/kubelet/kubelet-plugins/volume/exec/ `
--logtostderr=true `
--v=2

# --container-runtime=docker `
# --container-runtime-endpoint=unix:///var/run/dockershim.sock `

# --container-runtime=remote `
# --container-runtime-endpoint=unix:///run/kube-containerd/containerd.sock `

#
# $ kubectl --kubeconfig .\rpi\certs\kubectl.kubeconfig get csr --sort-by='{.metadata.creationTimestamp}'
#

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kubelet]

command=$command
stdout_logfile=/opt/k8s/log/kubelet-stdout.log
stderr_logfile=/opt/k8s/log/kubelet-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=60" > $PSScriptRoot/supervisor.d/kubelet.ini

if($args[1] -ne 'start'){
  exit
}

$env:ErrorActionPreference="stop"

wsl -u root -- /opt/k8s/bin/kubeadm version
wsl -u root -- ls /opt/k8s/bin/generate-kubelet-bootstrap-kubeconfig.sh

$env:ErrorActionPreference="continue"

wsl -u root -- /usr/sbin/swapoff -a
wsl -u root -- /sbin/swapoff -a
wsl -u root -- /opt/k8s/bin/generate-kubelet-bootstrap-kubeconfig.sh
wsl -u root -- mkdir -p /var/lib/kubelet

if (Test-Path $PSScriptRoot/conf/.wsl_ip){
   $wsl_ip_from_file=cat $PSScriptRoot/conf/.wsl_ip

   if($wsl_ip -eq $wsl_ip_from_file){
      Write-Warning "wsl ip not changed, skip rm cert"
   }else{
      Write-Warning "wsl ip changed, rm cert ..."
      echo $wsl_ip > $PSScriptRoot/conf/.wsl_ip
      wsl -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-*
   }
}else{
   Write-Warning "wsl ip changed, rm cert ..."
   echo $wsl_ip > $PSScriptRoot/conf/.wsl_ip
   wsl -u root -- rm -rf ${K8S_ROOT}/certs/kubelet-*
}

sleep 2

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  wsl -u root -- supervisorctl start kube-node:kubelet

  exit
}

if($args[0] -eq 'start'){
  wsl -u root -- bash -c $command
}
