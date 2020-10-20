# TODO

## 关闭全部非安全端口，所有端口必须启用 TLS

* 10248  kubelet         healthz
* 10249  kube-proxy      metrics
* 10251  kube-scheduler  metrics healthz
* 10256  kube-proxy      healthz

## 移除 Docker 相关内容

* https://github.com/kubernetes/kubernetes/pull/94624

## 使用 `kustomization.yaml` 自定义，尽量不修改源文件
