# Kubelet

## 初始化步骤

* 参考 `bin/generate-kubelet-bootstrap-kubeconfig.sh`

## 必须手动 approve server cert csr

**基于 [安全性考虑](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet-tls-bootstrapping/#certificate-rotation)，CSR approving controllers 不会（也不能）自动 approve kubelet server 证书签名请求，需要手动 approve。**

* https://github.com/opsnull/follow-me-install-kubernetes-cluster/issues/326
* https://github.com/opsnull/follow-me-install-kubernetes-cluster/issues/399
* https://github.com/kubernetes/kubernetes/issues/73356
* https://github.com/kubernetes/community/pull/1982

* 1.10 可以自动轮换 server 证书
* 1.11 删除了此功能 https://github.com/kubernetes/kubernetes/commit/7665f15b7d8d9006e410e41f6678cfa2be3ac602

> Note: The CSR approving controllers implemented in core Kubernetes do not approve node serving certificates for [security reasons](https://github.com/kubernetes/community/pull/1982). To use RotateKubeletServerCertificate operators need to run a custom approving controller, or manually approve the serving certificate requests.

未手动 approve 之前报错如下。

```bash
bootstrap.go:65] Using bootstrap kubeconfig to generate TLS client cert, key and kubeconfig file

bootstrap.go:96] No valid private key and/or certificate found, reusing existing private key or creating a new one
```

### 手动 approve

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
$ kubectl certificate approve <CSR_NAME>

$ kubectl describe csr CSR_NAME
```

## 特性

### 使用 TLS bootstrap 机制自动生成 client 和 server 证书，过期后自动轮转

* 过期，server 证书也得(必须) **手动 approve**

```bash
22:32:52.516590    5468 certificate_manager.go:556] Certificate expiration is 2020-09-07 15:27:50 +0000 UTC, rotation deadline is 2020-09-07 15:11:00.773330597 +0000 UTC

22:32:52.516652    5468 certificate_manager.go:288] Waiting 38m8.256684197s for next certificate rotation
...
23:11:00.785321    5468 certificate_manager.go:412] Rotating certificates

23:11:00.883560    5468 reflector.go:207] Starting reflector *v1.CertificateSigningRequest (0s) from k8s.io/client-go/tools/watch/informerwatcher.go:146
...
19:58:38.503176   15572 certificate_manager.go:414] certificate request was not signed: timed out waiting for the condition (未手动 approve 报错)
# 手动 approve 之后
23:20:19.916775    5468 csr.go:249] certificate signing request csr-kgd6x is approved, waiting to be issued

23:20:19.967255    5468 csr.go:245] certificate signing request csr-kgd6x is issued
# 在证书所在文件夹看到证书已经更新
```

* 假设过期时间设为 1 小时, `kubelet` 会在 `43` 分钟（具体时间看日志）时轮换

## Bootstrap Token Auth 和授予权限

`kublet` 启动时查找配置的 `--kubeletconfig` 文件是否存在，如果不存在则使用 `--bootstrap-kubeconfig` 向 `kube-apiserver` 发送证书签名请求 (CSR)。

`kube-apiserver` 收到 CSR 请求后，对其中的 Token 进行认证（事先使用 kubeadm 创建的 token），认证通过后将请求的 user 设置为 `system:bootstrap:`，group 设置为 `system:bootstrappers`，这一过程称为 Bootstrap Token Auth。

kubelet 启动后使用 `--bootstrap-kubeconfig` 向 kube-apiserver 发送 CSR 请求，当这个 CSR 被 approve 后，`kube-controller-manager` 为 kubelet 创建 TLS 客户端证书、私钥和 --kubeletconfig 文件。

### kubelet-client-current.pem

这是一个软连接文件，当 kubelet 配置了 `--feature-gates=RotateKubeletClientCertificate=true` 选项后，会在证书总有效期的 70%~90% 的时间内发起续期请求，请求被批准后会生成一个 `kubelet-client-时间戳.pem` `kubelet-client-current.pem` 文件则始终软连接到最新的真实证书文件，除首次启动外，kubelet 一直会使用这个证书同 apiserver 通讯

### kubelet-server-current.pem

同样是一个软连接文件，当 kubelet 配置了 `--feature-gates=RotateKubeletServerCertificate=true` 选项后，会在证书总有效期的 70%~90% 的时间内发起续期请求，请求被批准后会生成一个 `kubelet-server-时间戳.pem` `kubelet-server-current.pem` 文件则始终软连接到最新的真实证书文件，该文件将会一直被用于 kubelet 10250 api 端口鉴权

`kubelet-client.crt` 该文件在 kubelet 完成 TLS bootstrapping 后生成，此证书是由 `controller-manager` 签署的，此后 kubelet 将会加载该证书，用于与 apiserver 建立 TLS 通讯，同时使用该证书的 CN 字段作为用户名，O 字段作为用户组向 apiserver 发起其他请求
