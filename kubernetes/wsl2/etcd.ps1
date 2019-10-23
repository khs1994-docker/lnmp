. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

# $K8S_ETCD_HOST="192.168.199.100"
$K8S_ROOT=$PSScriptRoot

mkdir -Force "$HOME/.k8s-wsl2/log" | out-null

if($args[0] -eq 'stop'){
  stop-process (get-process etcd).Id

  exit
}

Start-Process -FilePath etcd `
  -WindowStyle Hidden `
  -RedirectStandardError "$HOME/.k8s-wsl2/log/etcd-err.log" `
  -RedirectStandardOutput "$HOME/.k8s-wsl2/log/etcd.log" `
  -WorkingDirectory "$HOME/.k8s-wsl2" `
  -ArgumentList (Write-Output --data-dir="$HOME/.k8s-wsl2" `
  --enable-v2=true `
  --name="node1" `
  --listen-peer-urls="https://${K8S_ETCD_HOST}:$K8S_ETCD_LISTEN_PEER_PORT" `
  --listen-client-urls="${K8S_ETCD_ENTRYPOINTS},http://127.0.0.1:${K8S_ETCD_LISTEN_CLIENT_PORT}" `
  --initial-advertise-peer-urls="https://${K8S_ETCD_HOST}:$K8S_ETCD_LISTEN_PEER_PORT" `
  --initial-cluster="node1=https://${K8S_ETCD_HOST}:$K8S_ETCD_LISTEN_PEER_PORT" `
  --initial-cluster-state="new" `
  --initial-cluster-token="mytoken" `
  --advertise-client-urls="$K8S_ETCD_ENTRYPOINTS" `
  --cert-file="${K8S_ROOT}/certs/etcd.pem" `
  --key-file="${K8S_ROOT}/certs/etcd-key.pem" `
  --client-cert-auth=true `
  --trusted-ca-file="${K8S_ROOT}/certs/ca.pem" `
  --peer-cert-file="${K8S_ROOT}/certs/etcd.pem" `
  --peer-key-file="${K8S_ROOT}/certs/etcd-key.pem" `
  --peer-client-cert-auth=true `
  --peer-trusted-ca-file="${K8S_ROOT}/certs/ca.pem").split(' ')

Start-Sleep 1

Get-Process etcd
