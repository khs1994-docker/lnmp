. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

(Get-Content $PSScriptRoot/conf/kube-proxy.config.yaml.temp) `
    -replace "##NODE_NAME##","wsl2" `
    -replace "##NODE_IP##",$wsl_ip `
    -replace "##K8S_ROOT##",$K8S_ROOT `
  | Set-Content $PSScriptRoot/conf/kube-proxy.config.yaml

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"
$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl pwd"

# WARNING: all flags other than
# --config,
# --write-config-to,
# and --cleanup are deprecated. Please begin using a config file ASAP.
$command=wsl -u root -- echo ${K8S_ROOT}/bin/kube-proxy `
--config=${K8S_WSL2_ROOT}/conf/kube-proxy.config.yaml `
--v=2

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-proxy]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kube-proxy-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kube-proxy-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-proxy.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- supervisorctl start kube-node:kube-proxy

  exit
}

if($args[0] -eq 'start'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- bash -c $command
}
