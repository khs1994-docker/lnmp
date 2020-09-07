. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$WINDOWS_ROOT_IN_WSL2 = wsl -d wsl-k8s -- wslpath "'$PSScriptRoot'"
$WINDOWS_HOME_IN_WSL2 = wsl -d wsl-k8s -- wslpath "'$HOME'"
$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

wsl -d wsl-k8s -u root -- mkdir -p ${K8S_ROOT}/etc/cni/net.d

wsl -d wsl-k8s -u root -- cp $WINDOWS_ROOT_IN_WSL2/conf/cni/99-loopback.conf ${K8S_ROOT}/etc/cni/net.d

# wsl -d wsl-k8s -u root -- cat ${K8S_ROOT}/cni/net.d/99-loopback.conf

(Get-Content $PSScriptRoot/conf/kube-containerd/1.4/config.toml.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
  -replace "90621", $env:USERNAME `
  -replace "my-registry", $MY_DOCKER_REGISTRY_MIRROR `
| Set-Content $PSScriptRoot/conf/kube-containerd/1.4/config.toml

$command = wsl -d wsl-k8s -u root -- echo $K8S_ROOT/bin/kube-containerd `
  --config ${WINDOWS_ROOT_IN_WSL2}/conf/kube-containerd/1.4/config.toml

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-containerd]

command=$command
stdout_logfile=${SUPERVISOR_LOG_ROOT}/kube-containerd-stdout.log
stderr_logfile=${SUPERVISOR_LOG_ROOT}/kube-containerd-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
stopasgroup=true
killasgroup=true
startsecs=10" > $PSScriptRoot/supervisor.d/kube-containerd.ini

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  wsl -d wsl-k8s -u root -- supervisorctl start kube-node:kube-containerd

  exit
}

if ($args[0] -eq 'start') {
  wsl -d wsl-k8s -u root -- bash -c $command
}
