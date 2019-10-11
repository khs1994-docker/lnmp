$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

$K8S_S_HOST=$wsl_ip
# $K8S_ROOT='/opt/k8s'

$command=wsl -u root -- echo /opt/k8s/bin/kube-scheduler `
--config=${K8S_ROOT}/conf/kube-scheduler.yaml `
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
stdout_logfile=/opt/k8s/log/kube-scheduler-stdout.log
stderr_logfile=/opt/k8s/log/kube-scheduler-error.log
directory=/
autostart=false
autorestart=false
startretries=10
user=root
startsecs=60" > $PSScriptRoot/supervisor.d/kube-scheduler.ini


if($args[1] -eq 'start'){
  wsl -u root -- bash -c $command
}
