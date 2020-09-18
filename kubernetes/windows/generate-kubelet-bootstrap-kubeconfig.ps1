# NODE_NAME
# KUBE_APISERVER

. $PSScriptRoot\..\wsl2\.env.ps1

$NODE_NAME="windows"
$KUBECTL_CONFIG_PATH="$PSScriptRoot\..\wsl2\certs\kubectl.kubeconfig"
$K8S_ROOT="C:\kubernetes"

do {
  "KUBE_APISERVER is unavailable - sleeping"
  sleep 3
} until ($(curl.exe -k --cacert ${PSScriptRoot}/../wsl2/certs/ca.pem ${KUBE_APISERVER}))

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/06-1.api-server.md#%E6%8E%88%E4%BA%88-kubernetes-%E8%AF%81%E4%B9%A6%E8%AE%BF%E9%97%AE-kubelet-api-%E7%9A%84%E6%9D%83%E9%99%90

kubectl create clusterrolebinding `
  kube-apiserver:kubelet-apis `
  --clusterrole=system:kubelet-api-admin `
  --user kubernetes `
  --kubeconfig ${KUBECTL_CONFIG_PATH}

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-2.kubelet.md#bootstrap-token-auth-%E5%92%8C%E6%8E%88%E4%BA%88%E6%9D%83%E9%99%90

kubectl create clusterrolebinding `
  kubelet-bootstrap `
  --clusterrole=system:node-bootstrapper `
  --group=system:bootstrappers `
  --kubeconfig ${KUBECTL_CONFIG_PATH}

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-2.kubelet.md#%E8%87%AA%E5%8A%A8-approve-csr-%E8%AF%B7%E6%B1%82

kubectl apply `
  -f ${PSScriptRoot}/../cfssl/csr-crb.yaml `
  --kubeconfig ${KUBECTL_CONFIG_PATH}

if (Test-Path ${K8S_ROOT}/etc/kubernetes/kubelet-bootstrap.kubeconfig ){exit 0}

$BOOTSTRAP_TOKEN=$(wsl -d wsl-k8s /wsl/wsl-k8s-data/k8s/bin/kubeadm token create `
      --description kubelet-bootstrap-token `
      --groups system:bootstrappers:${NODE_NAME} `
      --kubeconfig /wsl/wsl-k8s-data/k8s/etc/kubernetes/kubectl.kubeconfig)

    # 设置集群参数

    kubectl config set-cluster kubernetes `
      --certificate-authority=${PSScriptRoot}/../wsl2/certs/ca.pem `
      --embed-certs=true `
      --server=${KUBE_APISERVER} `
      --kubeconfig=${K8S_ROOT}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置客户端认证参数

    kubectl config set-credentials kubelet-bootstrap `
      --token=${BOOTSTRAP_TOKEN} `
      --kubeconfig=${K8S_ROOT}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置上下文参数

    kubectl config set-context default `
      --cluster=kubernetes `
      --user=kubelet-bootstrap `
      --kubeconfig=${K8S_ROOT}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置默认上下文

    kubectl config use-context default --kubeconfig=${K8S_ROOT}/etc/kubernetes/kubelet-bootstrap.kubeconfig
