#!/usr/bin/env bash

# NODE_NAME
# KUBE_APISERVER

set -x

if [ -n "$1" ];then K8S_ROOT="$1"; fi

if [ -f ${K8S_ROOT:-/opt/k8s}/.env ];then
  source ${K8S_ROOT:-/opt/k8s}/.env
fi

if [ -n "${WSL2_IP}" ];then
  cat ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet.config.yaml.temp \
  | sed \
  -e "s/##NODE_NAME##/${NODE_NAME}/g" \
  -e "s/##NODE_IP##/${WSL2_IP}/g" \
  -e "s!##K8S_ROOT##!${K8S_ROOT:-/opt/k8s}!g" \
  | tee ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet.config.yaml > /dev/null
fi

until curl --cacert ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/pki/ca.pem ${KUBE_APISERVER}; do
  >&2 echo "KUBE_APISERVER is unavailable - sleeping"
  sleep 3
done

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/06-1.api-server.md#%E6%8E%88%E4%BA%88-kubernetes-%E8%AF%81%E4%B9%A6%E8%AE%BF%E9%97%AE-kubelet-api-%E7%9A%84%E6%9D%83%E9%99%90

${K8S_ROOT:-/opt/k8s}/bin/kubectl create clusterrolebinding \
  kube-apiserver:kubelet-apis \
  --clusterrole=system:kubelet-api-admin \
  --user kubernetes \
  --kubeconfig ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubectl.kubeconfig

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-2.kubelet.md#bootstrap-token-auth-%E5%92%8C%E6%8E%88%E4%BA%88%E6%9D%83%E9%99%90

${K8S_ROOT:-/opt/k8s}/bin/kubectl create clusterrolebinding \
  kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --group=system:bootstrappers \
  --kubeconfig ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubectl.kubeconfig

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-2.kubelet.md#%E8%87%AA%E5%8A%A8-approve-csr-%E8%AF%B7%E6%B1%82

${K8S_ROOT:-/opt/k8s}/bin/kubectl apply \
  -f ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/csr-crb.yaml \
  --kubeconfig ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubectl.kubeconfig

if [ -f ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig ];then
  exit 0
fi

set -e

export BOOTSTRAP_TOKEN=$(${K8S_ROOT:-/opt/k8s}/bin/kubeadm token create \
      --description kubelet-bootstrap-token \
      --groups system:bootstrappers:${NODE_NAME} \
      --kubeconfig ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubectl.kubeconfig)

    # 设置集群参数
    ${K8S_ROOT:-/opt/k8s}/bin/kubectl config set-cluster kubernetes \
      --certificate-authority=${K8S_ROOT:-/opt/k8s}/etc/kubernetes/pki/ca.pem \
      --embed-certs=true \
      --server=${KUBE_APISERVER} \
      --kubeconfig=${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置客户端认证参数
    ${K8S_ROOT:-/opt/k8s}/bin/kubectl config set-credentials kubelet-bootstrap \
      --token=${BOOTSTRAP_TOKEN} \
      --kubeconfig=${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置上下文参数
    ${K8S_ROOT:-/opt/k8s}/bin/kubectl config set-context default \
      --cluster=kubernetes \
      --user=kubelet-bootstrap \
      --kubeconfig=${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置默认上下文
    ${K8S_ROOT:-/opt/k8s}/bin/kubectl config use-context default --kubeconfig=${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig

    chmod 644 ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig
