. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

$WINDOWS_ROOT_IN_WSL2 = Invoke-WSL wslpath "'$PSScriptRoot'"
$WINDOWS_HOME_IN_WSL2 = Invoke-WSL wslpath "'$HOME'"
$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

mkdir -Force $PSScriptRoot/conf/crio/crio.conf.d | Out-Null

Invoke-WSL mkdir -p ${K8S_ROOT}/etc/cni/net.d

Invoke-WSL cp $WINDOWS_ROOT_IN_WSL2/conf/cni/99-loopback.conf ${K8S_ROOT}/etc/cni/net.d

Invoke-WSL echo "runtime-endpoint: `"unix:///var/run/crio/crio.sock`"" `> ${K8S_ROOT}/etc/crictl.yaml
Invoke-WSL echo "image-endpoint: `"unix:///var/run/crio/crio.sock`"" `>`> ${K8S_ROOT}/etc/crictl.yaml

# Invoke-WSL cat ${K8S_ROOT}/cni/net.d/99-loopback.conf

(Get-Content $PSScriptRoot/conf/crio/crio.conf.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
  -replace "90621", $env:USERNAME `
  -replace "my-registry", $MY_DOCKER_REGISTRY_MIRROR `
| Set-Content $PSScriptRoot/conf/crio/crio.conf

(Get-Content $PSScriptRoot/conf/containers/storage.conf.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/containers/storage.conf

(Get-Content $PSScriptRoot/conf/containers/policy.json.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/containers/policy.json

(Get-Content $PSScriptRoot/conf/containers/containers.conf.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/containers/containers.conf

(Get-Content $PSScriptRoot/conf/containers/registries.d/default.yaml.temp) `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/containers/registries.d/default.yaml

Invoke-WSL cp -a $WINDOWS_ROOT_IN_WSL2/conf/containers/. ${K8S_ROOT}/etc/containers

$command = Invoke-WSL echo $K8S_ROOT/usr/local/bin/crio `
--pinns-path=$K8S_ROOT/usr/local/bin/pinns `
--hooks-dir=$K8S_ROOT/usr/local/share/containers/oci/hooks.d `
--config=$WINDOWS_ROOT_IN_WSL2/conf/crio/crio.conf `
--config-dir=$WINDOWS_ROOT_IN_WSL2/conf/crio/crio.conf.d `
--conmon-cgroup "pod" `
--conmon=$K8S_ROOT/usr/local/bin/conmon `
--listen /var/run/crio/crio.sock

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:cri-o]

command=$command
stdout_logfile=${SUPERVISOR_LOG_ROOT}/cri-o-stdout.log
stderr_logfile=${SUPERVISOR_LOG_ROOT}/cri-o-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
stopasgroup=true
killasgroup=true
startsecs=10" > $PSScriptRoot/supervisor.d/cri-o.ini

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  Invoke-WSL supervisorctl start kube-node:cri-o

  exit
}

if ($args[0] -eq 'start') {
  Invoke-WSL bash -c $command
}
