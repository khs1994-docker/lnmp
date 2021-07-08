$NODE_NAME="windows"
$K8S_ROOT="c:\kubernetes"
$NODE_IP="192.168.199.100"

kubelet `
--node-ip=$NODE_IP `
--bootstrap-kubeconfig=${K8S_ROOT}/etc/kubernetes/kubelet-bootstrap.kubeconfig `
--cert-dir=${K8S_ROOT}/etc/kubernetes/pki `
--root-dir=/var/lib/kubelet `
--kubeconfig=${K8S_ROOT}/etc/kubernetes/kubelet.kubeconfig `
--config=${PSScriptRoot}/etc/kubelet.config.yaml `
--hostname-override=${NODE_NAME} `
--volume-plugin-dir=${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ `
--logtostderr=true `
--container-runtime=remote `
--container-runtime-endpoint=npipe:////./pipe/containerd-containerd `
--v=6 `
--enforce-node-allocatable=""

# --container-runtime=docker `
# --container-runtime-endpoint= `
# --cni-cache-dir=/opt/k8s/var/lib/cni/cache `
# --pod-infra-container-image=mcr.microsoft.com/oss/kubernetes/pause:1.3.0 `
# --image-pull-progress-deadline=20m `
# --network-plugin=cni `
# --cni-bin-dir="C:\\bin\\cni" `
# --cni-conf-dir=$PSScriptRoot\etc\cni `

# --container-runtime=remote `
# --container-runtime-endpoint=npipe:////./pipe/containerd-containerd `

# --windows-service `
