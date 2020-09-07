# 请同步更改
# `.env` 中的 K8S_ROOT=/wsl/wsl-k8s-data/k8s
$K8S_ROOT='/wsl/wsl-k8s-data/k8s'

# Windows 固定 IP

$K8S_ETCD_LISTEN_CLIENT_PORT=12379
$K8S_ETCD_LISTEN_PEER_PORT=12380
$K8S_ETCD_ENTRYPOINTS="https://windows.k8s.khs1994.com:${K8S_ETCD_LISTEN_CLIENT_PORT}"

$KUBE_APISERVER="https://wsl2.k8s.khs1994.com:6443"

# WSL2 domain
# 解析到 WSL2 的域名，每个变量最好不要超过 5 个值

$WSL2_DOMAIN="wsl.t.khs1994.com","test2.t.khs1994.com"
$WSL2_DOMAIN_1=""
$WSL2_DOMAIN_2=""
# $WSL2_DOMAIN_20=""

# 替换为自己的镜像源，例如 阿里云
$MY_DOCKER_REGISTRY_MIRROR="my-registry"

$CRI="containerd"

# $CRI="cri-o"

# $CNI_CALICO_EBPF="false"
