. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$wsl_ip = wsl -d wsl-k8s -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

(Get-Content $PSScriptRoot/conf/kube-proxy.config.yaml.temp) `
  -replace "##NODE_NAME##", "wsl2" `
  -replace "##NODE_IP##", $wsl_ip `
  -replace "##K8S_ROOT##", $K8S_ROOT `
| Set-Content $PSScriptRoot/conf/kube-proxy.config.yaml

$WINDOWS_ROOT_IN_WSL2 = wsl -d wsl-k8s -- wslpath "'$PSScriptRoot'"
$WINDOWS_HOME_IN_WSL2 = wsl -d wsl-k8s -- wslpath "'$HOME'"
$SUPERVISOR_LOG_ROOT="${WINDOWS_HOME_IN_WSL2}/.khs1994-docker-lnmp/wsl-k8s/log"

# WARNING: all flags other than
# --config,
# --write-config-to,
# and --cleanup are deprecated. Please begin using a config file ASAP.
$command = wsl -d wsl-k8s -u root -- echo ${K8S_ROOT}/bin/kube-proxy `
  --config=${WINDOWS_ROOT_IN_WSL2}/conf/kube-proxy.config.yaml `
  --feature-gates="IPv6DualStack=true" `
  --cluster-cidr=10.244.0.0/16,fc00::/48 `
  --v=2

mkdir -Force $PSScriptRoot/supervisor.d | out-null

echo "[program:kube-proxy]

command=$command
stdout_logfile=${SUPERVISOR_LOG_ROOT}/kube-proxy-stdout.log
stderr_logfile=${SUPERVISOR_LOG_ROOT}/kube-proxy-error.log
directory=/
autostart=false
autorestart=false
startretries=2
user=root
startsecs=10" > $PSScriptRoot/supervisor.d/kube-proxy.ini

if ($args[0] -eq 'start' -and $args[1] -eq '-d') {
  & $PSScriptRoot/bin/wsl2host-check
  wsl -d wsl-k8s -u root -- supervisorctl start kube-node:kube-proxy

  exit
}

if ($args[0] -eq 'start') {
  & $PSScriptRoot/bin/wsl2host-check
  wsl -d wsl-k8s -u root -- bash -c $command
}
