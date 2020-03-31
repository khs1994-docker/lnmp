# TODO

## 关闭全部非安全端口，所有端口必须启用 TLS

* 10248  kubelet         healthz
* 10249  kube-proxy      metrics
* 10251  kube-scheduler  metrics healthz
* 10256  kube-proxy      healthz

## 分离集群 CA 和 Etcd CA
