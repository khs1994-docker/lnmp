# 新节点加入

## Docker/Containerd/CRI-O(容器运行时)

## kubelet

## kube-proxy

## 复制文件

将以下文件从主节点复制到从节点

```bash
$ scp khs1994@192.168.199.100:/home/khs1994/lnmp/kubernetes/systemd/certs/{kubelet.config.yaml,\
kube-proxy.config.yaml,\
csr-crb.yaml,\
kubectl.kubeconfig,\
kube-proxy.kubeconfig,\
etcd-client.pem,\
etcd-client-key.pem} .
```
