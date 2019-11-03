. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

$K8S_S_HOST=$wsl_ip
# $K8S_ROOT='/opt/k8s'

$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"
$WINDOWS_HOME_ON_WSL2=powershell -c "cd $HOME ; wsl pwd"

(Get-Content $PSScriptRoot/conf/kube-scheduler.config.yaml.temp) `
    -replace "##NODE_IP##",$wsl_ip `
    -replace "##K8S_ROOT##",$K8S_ROOT `
  | Set-Content $PSScriptRoot/conf/kube-scheduler.config.yaml

$command=wsl -u root -- echo ${K8S_ROOT}/bin/kube-scheduler `
--config=${K8S_WSL2_ROOT}/conf/kube-scheduler.config.yaml `
--bind-address=${K8S_S_HOST} `
--secure-port=10259 `
--port=0 `
--tls-cert-file=${K8S_ROOT}/certs/kube-scheduler.pem `
--tls-private-key-file=${K8S_ROOT}/certs/kube-scheduler-key.pem `
--authentication-kubeconfig=${K8S_ROOT}/conf/kube-scheduler.kubeconfig `
--client-ca-file=${K8S_ROOT}/certs/ca.pem `
--requestheader-allowed-names="" `
--requestheader-client-ca-file=${K8S_ROOT}/certs/ca.pem `
--requestheader-extra-headers-prefix="X-Remote-Extra-" `
--requestheader-group-headers=X-Remote-Group `
--requestheader-username-headers=X-Remote-User `
--authorization-kubeconfig=${K8S_ROOT}/conf/kube-scheduler.kubeconfig `
--logtostderr=true `
--v=2

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-scheduler]

command=$command
stdout_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kube-scheduler-stdout.log
stderr_logfile=${WINDOWS_HOME_ON_WSL2}/.khs1994-docker-lnmp/k8s-wsl2/log/kube-scheduler-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-scheduler.ini

if($args[0] -eq 'start' -and $args[1] -eq '-d'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- supervisorctl start kube-server:kube-scheduler

  exit
}

if($args[0] -eq 'start'){
  & $PSScriptRoot/bin/wsl2host-check
  wsl -u root -- bash -c $command
}
