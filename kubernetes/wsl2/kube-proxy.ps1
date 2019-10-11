$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

(Get-Content $PSScriptRoot/conf/kube-proxy.config.yaml.temp) `
    -replace "##NODE_NAME##","wsl2" `
    -replace "##NODE_IP##",$wsl_ip `
  | Set-Content $PSScriptRoot/conf/kube-proxy.config.yaml

$K8S_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

wsl -u root -- /opt/k8s/bin/kube-proxy `
--config=${K8S_ROOT}/conf/kube-proxy.config.yaml `
--logtostderr=true `
--v=2
