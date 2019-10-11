. $PSScriptRoot/../rpi/.env.example.ps1
. $PSScriptRoot/../rpi/.env.ps1

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

wsl -u root -- cp $K8S_WSL2_ROOT/conf/cni/10-flannel.conflist /opt/k8s/cni/net.d

wsl -u root -- cat /opt/k8s/cni/net.d/10-flannel.conflist

$command=wsl -u root -- echo /usr/bin/containerd `
--config ${K8S_WSL2_ROOT}/conf/kube-containerd/config.toml

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-containerd]

command=$command
stdout_logfile=/opt/k8s/log/kube-containerd-stdout.log
stderr_logfile=/opt/k8s/log/kube-containerd-error.log
directory=/
autostart=false
autorestart=false
startretries=10
user=root
startsecs=60" > $PSScriptRoot/supervisor.d/kube-containerd.ini

if($args[1] -eq 'start'){
  wsl -u root -- bash -c $command
}
