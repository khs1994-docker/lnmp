# Kubelet

## 自动 Approved 证书失败

* https://github.com/opsnull/follow-me-install-kubernetes-cluster/issues/326

* 状态： 正在排查

```bash
$ kubectl get csr

$ kubectl certificate approve CSR_NAME

$ kubectl describe csr CSR_NAME
```

```bash
bootstrap.go:65] Using bootstrap kubeconfig to generate TLS client cert, key and kubeconfig file

bootstrap.go:96] No valid private key and/or certificate found, reusing existing private key or creating a new one
```
