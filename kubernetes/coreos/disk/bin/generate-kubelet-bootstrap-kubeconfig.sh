#!/usr/bin/env bash

set -x

until curl --cacert /etc/kubernetes/certs/ca.pem ${KUBE_APISERVER}; do
  >&2 echo "KUBE_APISERVER is unavailable - sleeping"
  sleep 3
done

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/06-1.api-server.md#%E6%8E%88%E4%BA%88-kubernetes-%E8%AF%81%E4%B9%A6%E8%AE%BF%E9%97%AE-kubelet-api-%E7%9A%84%E6%9D%83%E9%99%90

su - k8s -c "/opt/bin/kubectl create clusterrolebinding kube-apiserver:kubelet-apis --clusterrole=system:kubelet-api-admin --user kubernetes"

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-2.kubelet.md#bootstrap-token-auth-%E5%92%8C%E6%8E%88%E4%BA%88%E6%9D%83%E9%99%90

su - k8s -c "/opt/bin/kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --group=system:bootstrappers"

# https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-2.kubelet.md#%E8%87%AA%E5%8A%A8-approve-csr-%E8%AF%B7%E6%B1%82

su - k8s -c "/opt/bin/kubectl apply -f /etc/kubernetes/csr-crb.yaml"

if [ -f /etc/kubernetes/kubelet-bootstrap.kubeconfig ];then
  exit 0
fi

set -e

export BOOTSTRAP_TOKEN=$(/opt/bin/kubeadm token create \
      --description kubelet-bootstrap-token \
      --groups system:bootstrappers:${NODE_NAME} \
      --kubeconfig /home/k8s/.kube/config)

    # 设置集群参数
    /opt/bin/kubectl config set-cluster kubernetes \
      --certificate-authority=/etc/kubernetes/certs/ca.pem \
      --embed-certs=true \
      --server=${KUBE_APISERVER} \
      --kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置客户端认证参数
    /opt/bin/kubectl config set-credentials kubelet-bootstrap \
      --token=${BOOTSTRAP_TOKEN} \
      --kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置上下文参数
    /opt/bin/kubectl config set-context default \
      --cluster=kubernetes \
      --user=kubelet-bootstrap \
      --kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig

    # 设置默认上下文
    /opt/bin/kubectl config use-context default --kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig

    chmod 644 /etc/kubernetes/kubelet-bootstrap.kubeconfig
