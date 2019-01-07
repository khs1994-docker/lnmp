# Kubelet

## 自动 Approved 证书失败

* https://github.com/opsnull/follow-me-install-kubernetes-cluster/issues/326

* 状态： 正在排查

### 错误详情

```bash
bootstrap.go:65] Using bootstrap kubeconfig to generate TLS client cert, key and kubeconfig file

bootstrap.go:96] No valid private key and/or certificate found, reusing existing private key or creating a new one
```

### 解决办法

```bash
$ kubectl get csr

NAME                                                   AGE     REQUESTOR                 CONDITION
csr-4gzpq                                              4m20s   system:node:node1         Pending
csr-62qp7                                              50m     system:node:node1         Pending
csr-6ml4w                                              12m     system:node:node1         Pending
csr-8nvc2                                              63m     system:node:node1         Pending
csr-f6gbd                                              38m     system:node:node1         Pending
csr-sjthd                                              25m     system:node:node1         Pending
csr-sxjxf                                              2m41s   system:node:node1         Pending
node-csr-j1Ja8wpP3FxFBMnEVNsrwYosgWk_-796bWmRg9cnFTE   63m     system:bootstrap:fp7k2i   Approved,Issued

# approve 倒数第二个，例如
# $ kubectl certificate approve csr-sxjxf
$ kubectl certificate approve CSR_NAME

$ kubectl describe csr CSR_NAME
```

## 特性

* 使用 TLS bootstrap 机制自动生成 client 和 server 证书，过期后自动轮转；

## Bootstrap Token Auth 和授予权限

`kublet` 启动时查找配置的 `--kubeletconfig` 文件是否存在，如果不存在则使用 `--bootstrap-kubeconfig` 向 `kube-apiserver` 发送证书签名请求 (CSR)。

kube-apiserver 收到 CSR 请求后，对其中的 Token 进行认证（事先使用 kubeadm 创建的 token），认证通过后将请求的 user 设置为 system:bootstrap:，group 设置为 system:bootstrappers，这一过程称为 Bootstrap Token Auth。

kubelet 启动后使用 --bootstrap-kubeconfig 向 kube-apiserver 发送 CSR 请求，当这个 CSR 被 approve 后，kube-controller-manager 为 kubelet 创建 TLS 客户端证书、私钥和 --kubeletconfig 文件。

## pause

* https://github.com/rootsongjc/kubernetes-handbook/blob/master/concepts/pause-container.md
