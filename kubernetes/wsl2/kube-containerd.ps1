. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

$WINDOWS_ROOT_IN_WSL2 = Invoke-WSLK8S wslpath "'$PSScriptRoot'"
$WINDOWS_HOME_IN_WSL2 = Invoke-WSLK8S wslpath "'$HOME'"
$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

Invoke-WSLK8S mkdir -p ${K8S_ROOT}/etc/cni/net.d

Invoke-WSLK8S cp $WINDOWS_ROOT_IN_WSL2/conf/cni/99-loopback.conf ${K8S_ROOT}/etc/cni/net.d

# Invoke-WSLK8S cat ${K8S_ROOT}/cni/net.d/99-loopback.conf

(Get-Content $PSScriptRoot/conf/kube-containerd/1.4/config.toml.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
  -replace "90621", $env:USERNAME `
  -replace "my-registry", $MY_DOCKER_REGISTRY_MIRROR `
| Set-Content $PSScriptRoot/conf/kube-containerd/1.4/config.toml

$command = Invoke-WSLK8S echo $K8S_ROOT/bin/kube-containerd `
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
  Invoke-WSLK8S supervisorctl start kube-node:kube-containerd

  exit
}

if ($args[0] -eq 'start') {
  Invoke-WSLK8S bash -c $command
}
