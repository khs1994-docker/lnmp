# WSL2 Kubernetes 节点

## 注意事项

* 问题1: WSL2 暂时不能固定 IP,每次重启必须执行 `$ kubectl certificate approve csr-XXXX`
* Windows 固定 IP `192.168.199.100`
* WSL2 `Ubuntu-18.04` 设为默认 WSL

## master

`etcd` `kube-apiserver` `kube-controller-manager` `kube-scheduler`

以上节点请参考 [kube-server](README.SERVER.md)

## node

### 复制文件

```bash
$ wsl

$ sudo cp -a kubernetes-release/release/v1.16.1-linux-amd64/kubernetes/server/bin/kube{-proxy,ctl,let,adm} \
    /opt/k8s/bin
```

```powershell
$ $items="kubelet-config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","flanneld.pem","flanneld-key.pem"

$ foreach($item in $items){cp ./wsl2/certs/$item systemd/certs}
```

### join

```bash
# 编辑 systemd/.env

KUBE_APISERVER=https://192.168.199.100:16443

$ wsl

$ ./lnmp-k8s join 192.168.199.100 --containerd --skip-cp-k8s-bin
```

## flanneld

```bash
$ ./wsl2/flanneld start
```

## kube-proxy

```bash
$ ./wsl2/kube-proxy start
```

## kube-containerd

```bash
$ ./wsl2/kube-containerd start
```

## kubelet

```bash
$ ./wsl2/kubelet start
```

## 使用 supervisor 管理组件

安装配置请参考 [kube-server](README.SERVER.md)

生成配置文件

```bash
$ ./wsl2/flanneld
$ ./wsl2/kube-containerd

# 以下两个组件命令, 包含 WSL2 ip,故每次启动时必须生成新的配置文件
$ ./wsl2/kube-proxy
$ ./wsl2/kubelet

# 复制配置文件
$ wsl -u root -- cp wsl2/supervisor.d/*.ini /etc/supervisor.d/
```

重新加载配置

```bash
$ ./wsl2/bin/supervisorctl update
```

启动组件

```bash
$ ./wsl2/bin/supervisorctl start kube-node:flanneld
$ ./wsl2/bin/supervisorctl start kube-node:kube-proxy
$ ./wsl2/bin/supervisorctl start kube-node:kube-containerd
$ ./wsl2/bin/supervisorctl start kube-node:kubelet

# 启动全部组件
$ ./wsl2/bin/supervisorctl start kube-node:
```

## 总结

启动组件有三种方式,下面以 `kube-proxy` 组件为例,其他组件同理

```bash
# 会占据窗口
$ ./wsl2/kube-proxy start
```

```bash
$ ./wsl2/bin/supervisorctl start kube-node:kube-proxy
```

```bash
$ ./wsl2/kube-proxy start -d
```

### 一键启动

有两种方式

```bash
$ ./wsl2/bin/supervisorctl start kube-node:
```

```bash
$ ./wsl2/bin/kube-node
```

## 参考

```bash
# 相当于关闭虚拟机
$ wsl --shutdown
```

* https://github.com/kubernetes-sigs/kind/blob/master/site/content/docs/user/using-wsl2.md
