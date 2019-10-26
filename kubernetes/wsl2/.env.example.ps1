# 请同步更改
# `.env` 中的 K8S_ROOT=/wsl/k8s-data/k8s
$K8S_ROOT='/wsl/k8s-data/k8s'

# Windows 固定 IP
$WINDOWS_HOST="192.168.199.100"

$K8S_ETCD_LISTEN_CLIENT_PORT=2379
$K8S_ETCD_LISTEN_PEER_PORT=2380
$K8S_ETCD_HOST=$WINDOWS_HOST
$K8S_ETCD_ENTRYPOINTS="https://${WINDOWS_HOST}:${K8S_ETCD_LISTEN_CLIENT_PORT}"

$KUBE_APISERVER="https://${WINDOWS_HOST}:16443"

# WSL2 domain
# 解析到 WSL2 的域名

$WSL2_DOMAIN="wsl.t.khs1994.com","test2.t.khs1994.com","wsl2.docker.internal"
