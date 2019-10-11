$K8S_ROOT="/opt/k8s"
$K8S_ETCD_ENTRYPOINTS="https://192.168.199.100:2379"

wsl -u root -- mkdir --parents /var/lib/coreos /run/flannel

$env:ETCDCTL_API=2

etcdctl `
  --endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --ca-file="$PSScriptRoot/../rpi/certs/ca.pem" `
  --cert-file="$PSScriptRoot/../rpi/certs/flanneld.pem" `
  --key-file="$PSScriptRoot/../rpi/certs/flanneld-key.pem" `
  get /kubernetes/network/config

if (!($?)){
  Write-Warning "flanneld etcd config not found, config ..."

  etcdctl `
  --endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --ca-file="$PSScriptRoot/../rpi/certs/ca.pem" `
  --cert-file="$PSScriptRoot/../rpi/certs/flanneld.pem" `
  --key-file="$PSScriptRoot/../rpi/certs/flanneld-key.pem" `
  set /kubernetes/network/config `
  $('{"Network":"172.30.0.0/16","SubnetLen":24,"Backend":{"Type":"vxlan"}}' | ConvertTo-Json)
}

wsl -u root -- /opt/k8s/bin/flanneld `
  --etcd-endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --etcd-cafile="${K8S_ROOT}/certs/ca.pem" `
  --etcd-certfile="${K8S_ROOT}/certs/flanneld.pem" `
  --etcd-keyfile="${K8S_ROOT}/certs/flanneld-key.pem" `
  --etcd-prefix="/kubernetes/network" `
  --ip-masq
