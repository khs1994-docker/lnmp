. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

# $K8S_ETCD_HOST="192.168.199.100"
$K8S_ROOT=$PSScriptRoot

mkdir -Force "$HOME/.k8s-rpi" | out-null

RunHiddenConsole.exe etcd `
  --data-dir="$HOME/.k8s-rpi" `
  --enable-v2=true `
  --name="node1" `
  --listen-peer-urls="https://${K8S_ETCD_HOST}:2380" `
  --listen-client-urls="https://${K8S_ETCD_HOST}:2379,http://127.0.0.1:2379" `
  --initial-advertise-peer-urls="https://${K8S_ETCD_HOST}:2380" `
  --initial-cluster="node1=https://${K8S_ETCD_HOST}:2380" `
  --initial-cluster-state="new" `
  --initial-cluster-token="mytoken" `
  --advertise-client-urls="https://${K8S_ETCD_HOST}:2379" `
  --cert-file="${K8S_ROOT}/certs/etcd.pem" `
  --key-file="${K8S_ROOT}/certs/etcd-key.pem" `
  --client-cert-auth=true `
  --trusted-ca-file="${K8S_ROOT}/certs/ca.pem" `
  --peer-cert-file="${K8S_ROOT}/certs/etcd.pem" `
  --peer-key-file="${K8S_ROOT}/certs/etcd-key.pem" `
  --peer-client-cert-auth=true `
  --peer-trusted-ca-file="${K8S_ROOT}/certs/ca.pem"
