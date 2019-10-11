# WSL2 Kubernetes

## 注意事项

* 问题1: WSL2 暂时不能固定 IP,每次重启必须执行 `$ kubectl certificate approve csr-XXXX`
* Windows 固定 IP `192.168.199.100`
* WSL2 `Ubuntu-18.04` 并设为默认 WSL

## master

`etcd` `kube-apiserver` `kube-controller-manager` `kube-scheduler`

以上节点请参考 [rpi](../rpi)

## node

## 复制文件

```bash
$ wsl

$ sudo cp -a kubernetes-release/release/v1.16.1-linux-amd64/kubernetes/server/bin/kube{-proxy,ctl,let,adm} \
    /opt/k8s/bin
```

```powershell
$ $items="kubelet-config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","flanneld.pem","flanneld-key.pem"

$ foreach($item in $items){cp ./rpi/certs/$item systemd/certs}
```

## join

```bash
# 编辑 systemd/.env
# KUBE_APISERVER=https://192.168.199.100:6443

$ wsl

$ ./lnmp-k8s join 192.168.199.100 --containerd --skip-cp-k8s-bin
```

## flanneld

```bash
$ ./wsl2/flanneld
```

## kube-proxy

```bash
$ ./wsl2/kube-proxy
```

## kube-containerd

```bash
$ ./wsl2/kube-containerd
```

## kubelet

```bash
$ ./wsl2/kubelet
```
