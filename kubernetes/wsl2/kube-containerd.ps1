. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"
$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl pwd"

wsl -u root -- mkdir -p ${K8S_ROOT}/etc/cni/net.d

wsl -u root -- cp $K8S_WSL2_ROOT/conf/cni/99-loopback.conf ${K8S_ROOT}/etc/cni/net.d

# wsl -u root -- cat ${K8S_ROOT}/cni/net.d/99-loopback.conf

(Get-Content $PSScriptRoot/conf/kube-containerd/1.3/config.toml.temp) `
  -replace "##K8S_ROOT##",$K8S_ROOT `
  | Set-Content $PSScriptRoot/conf/kube-containerd/1.3/config.toml

$command=wsl -u root -- echo $K8S_ROOT/bin/kube-containerd `
--config ${K8S_WSL2_ROOT}/conf/kube-containerd/1.3/config.toml

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-containerd]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kube-containerd-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kube-containerd-error.log
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
