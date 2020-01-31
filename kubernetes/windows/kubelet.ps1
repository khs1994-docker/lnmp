$NODE_NAME="windows"
$K8S_ROOT="c:\kubernetes"
$ip="192.168.199.100"

kubelet `
--node-ip=$ip `
--bootstrap-kubeconfig=${K8S_ROOT}/conf/kubelet-bootstrap.kubeconfig `
--cert-dir=${K8S_ROOT}/certs `
--root-dir=/var/lib/kubelet `
--kubeconfig=${K8S_ROOT}/conf/kubelet.kubeconfig `
--config=${PSScriptRoot}/etc/kubelet.config.yaml `
--hostname-override=${NODE_NAME} `
--volume-plugin-dir=${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ `
--logtostderr=true `
--dynamic-config-dir=${K8S_ROOT}/var/lib/kubelet/dynamic-config `
--experimental-check-node-capabilities-before-mount=true `
--v=2 `
--pod-infra-container-image=mcr.microsoft.com/k8s/core/pause:1.2.0 `
--image-pull-progress-deadline=20m `
--network-plugin=cni `
--cni-bin-dir="C:\\bin\\cni" `
--cni-conf-dir=$PSScriptRoot\etc\cni `

# --container-runtime=docker `
# --container-runtime-endpoint= `
# --cni-cache-dir=/opt/k8s/var/lib/cni/cache `

# --container-runtime=remote `
# --container-runtime-endpoint=npipe:////./pipe/containerd-containerd `

# --windows-service `
