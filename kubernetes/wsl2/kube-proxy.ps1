. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

(Get-Content $PSScriptRoot/conf/kube-proxy.config.yaml.temp) `
    -replace "##NODE_NAME##","wsl2" `
    -replace "##NODE_IP##",$wsl_ip `
  | Set-Content $PSScriptRoot/conf/kube-proxy.config.yaml

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

$command=wsl -u root -- echo ${K8S_ROOT}/bin/kube-proxy `
--config=${K8S_WSL2_ROOT}/conf/kube-proxy.config.yaml `
--logtostderr=true `
--v=2

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-proxy]

command=$command
stdout_logfile=${K8S_ROOT}/log/kube-proxy-stdout.log
stderr_logfile=${K8S_ROOT}/log/kube-proxy-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-proxy.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  wsl -u root -- supervisorctl start kube-node:kube-proxy

  exit
}

if($args[0] -eq 'start'){
  wsl -u root -- bash -c $command
}
