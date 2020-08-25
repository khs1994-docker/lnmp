. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1

$K8S_ETCD_HOST = "127.0.0.1"
$K8S_ROOT = $PSScriptRoot

if (!(Test-Path $K8S_ROOT\certs\etcd.pem)) {
  write-host "Please generate cert first, see README.SERVER.md" -ForegroundColor Red

  exit 1
}

mkdir -Force "$HOME/.khs1994-docker-lnmp/wsl-k8s/etcd" | out-null
mkdir -Force "$HOME/.khs1994-docker-lnmp/wsl-k8s/log" | out-null

if ($args[0] -eq 'stop') {
  stop-process (get-process etcd).Id

  exit
}

Start-Process -FilePath etcd `
  -WindowStyle Hidden `
  -RedirectStandardError "$HOME/.khs1994-docker-lnmp/wsl-k8s/log/etcd-err.log" `
  -RedirectStandardOutput "$HOME/.khs1994-docker-lnmp/wsl-k8s/log/etcd.log" `
  -WorkingDirectory "$HOME/.khs1994-docker-lnmp/wsl-k8s/etcd" `
  -ArgumentList (Write-Output --data-dir="$HOME/.khs1994-docker-lnmp/wsl-k8s/etcd" `
    --enable-v2=false `
    --name="node1" `
    --listen-peer-urls="https://${K8S_ETCD_HOST}:$K8S_ETCD_LISTEN_PEER_PORT" `
    --listen-client-urls="https://0.0.0.0:${K8S_ETCD_LISTEN_CLIENT_PORT},http://127.0.0.1:${K8S_ETCD_LISTEN_CLIENT_PORT}" `
    --initial-advertise-peer-urls="https://${K8S_ETCD_HOST}:$K8S_ETCD_LISTEN_PEER_PORT" `
    --initial-cluster="node1=https://${K8S_ETCD_HOST}:$K8S_ETCD_LISTEN_PEER_PORT" `
    --initial-cluster-state="new" `
    --initial-cluster-token="mytoken" `
    --advertise-client-urls="http://${K8S_ETCD_HOST}:${K8S_ETCD_LISTEN_CLIENT_PORT}" `
    --cert-file="${K8S_ROOT}/certs/etcd.pem" `
    --key-file="${K8S_ROOT}/certs/etcd-key.pem" `
    --client-cert-auth=true `
    --trusted-ca-file="${K8S_ROOT}/certs/etcd-ca.pem" `
    --peer-cert-file="${K8S_ROOT}/certs/etcd-peer.pem" `
    --peer-key-file="${K8S_ROOT}/certs/etcd-peer-key.pem" `
    --peer-client-cert-auth=true `
    --peer-trusted-ca-file="${K8S_ROOT}/certs/etcd-ca.pem").split(' ')

Start-Sleep 1

Get-Process etcd
