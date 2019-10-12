. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

wsl -u root -- mkdir -p ${K8S_ROOT}/cni/net.d

wsl -u root -- cp $K8S_WSL2_ROOT/conf/cni/10-flannel.conflist ${K8S_ROOT}/cni/net.d

wsl -u root -- cat ${K8S_ROOT}/cni/net.d/10-flannel.conflist

(Get-Content $PSScriptRoot/conf/kube-containerd/config.toml.temp) `
  -replace "##K8S_ROOT##",$K8S_ROOT `
  | Set-Content $PSScriptRoot/conf/kube-containerd/config.toml

$command=wsl -u root -- echo /usr/bin/containerd `
--config ${K8S_WSL2_ROOT}/conf/kube-containerd/config.toml

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-containerd]

command=$command
stdout_logfile=${K8S_ROOT}/log/kube-containerd-stdout.log
stderr_logfile=${K8S_ROOT}/log/kube-containerd-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-containerd.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  wsl -u root -- supervisorctl start kube-node:kube-containerd

  exit
}

if($args[0] -eq 'start'){
  wsl -u root -- bash -c $command
}
