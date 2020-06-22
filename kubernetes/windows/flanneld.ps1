. $PSScriptRoot\..\wsl2\.env.ps1

$ip="192.168.199.100"

flanneld `
--iface=$ip `
--ip-masq=1 `
--etcd-endpoints=${K8S_ETCD_ENTRYPOINTS} `
--etcd-cafile="$PSScriptRoot/../wsl2/certs/etcd-ca.pem" `
--etcd-certfile="$PSScriptRoot/../wsl2/certs/flanneld-etcd-client.pem" `
--etcd-keyfile="$PSScriptRoot/../wsl2/certs/flanneld-etcd-client-key.pem" `
--etcd-prefix="/kubernetes/network"
