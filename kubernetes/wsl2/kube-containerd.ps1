. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl -d wsl-k8s pwd"
$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl -d wsl-k8s pwd"

wsl -d wsl-k8s -u root -- mkdir -p ${K8S_ROOT}/etc/cni/net.d

wsl -d wsl-k8s -u root -- cp $K8S_WSL2_ROOT/conf/cni/99-loopback.conf ${K8S_ROOT}/etc/cni/net.d

# wsl -d wsl-k8s -u root -- cat ${K8S_ROOT}/cni/net.d/99-loopback.conf

(Get-Content $PSScriptRoot/conf/kube-containerd/1.3/config.toml.temp) `
  -replace "##K8S_ROOT##",$K8S_ROOT `
  -replace "90621",$env:USERNAME `
  | Set-Content $PSScriptRoot/conf/kube-containerd/1.3/config.toml

$command=wsl -d wsl-k8s -u root -- echo $K8S_ROOT/bin/kube-containerd `
--config ${K8S_WSL2_ROOT}/conf/kube-containerd/1.3/config.toml

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-containerd]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log/kube-containerd-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log/kube-containerd-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
stopsignal=HUP
startsecs=10" > $PSScriptRoot/supervisor.d/kube-containerd.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  wsl -d wsl-k8s -u root -- supervisorctl start kube-node:kube-containerd

  exit
}

if($args[0] -eq 'start'){
  wsl -d wsl-k8s -u root -- bash -c $command
}
