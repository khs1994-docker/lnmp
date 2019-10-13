# WSL2 Kubernetes 节点 ($ ./wsl2/bin/kube-node)

## 注意事项

* 问题1: WSL2 暂时不能固定 IP,每次重启必须执行 `$ kubectl certificate approve csr-XXXX`
* WSL2 IP 变化时必须重启 `kube-nginx`
* Windows 固定 IP `192.168.199.100`
* WSL2 `Ubuntu-18.04` 设为默认 WSL
* 由于缺少文件 `kube-proxy` 不能使用 `ipvs` 模式,解决办法请查看 [编译 WSL2 内核](README.KERNEL.md)

## master

`etcd` `kube-apiserver` `kube-controller-manager` `kube-scheduler`

以上节点请参考 [kube-server](README.SERVER.md)

## node

### 复制文件

```bash
$ wsl

$ source ./wsl2/.env
$ sudo cp -a kubernetes-release/release/v1.16.1-linux-amd64/kubernetes/server/bin/kube{-proxy,ctl,let,adm} ${K8S_ROOT:-/opt/k8s}/bin
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

```powershell
$ ./wsl2/flanneld start
```

## kube-proxy

```powershell
$ ./wsl2/kube-proxy start
```

## kube-containerd

```powershell
$ ./wsl2/kube-containerd start
```

## kubelet

```powershell
$ ./wsl2/kubelet start
```

## 使用 supervisor 管理组件

* http://www.supervisord.org/running.html#running-supervisorctl

安装配置请参考 [kube-server](README.SERVER.md)

### 命令封装

* 使用 `./wsl2/bin/supervisord` 封装 `supervisord`
* 使用 `./wsl2/bin/supervisorctl` 封装 `supervisorctl` 并增加了额外的命令

### 1. 生成配置文件

```powershell
# $ ./wsl2/flanneld
# $ ./wsl2/kube-containerd

$ ./wsl2/bin/supervisorctl g
```

### 2. 重新加载配置

```powershell
# 复制配置文件,无需执行! ./wsl2/bin/supervisorctl update 已对该命令进行了封装
# $ wsl -u root -- cp wsl2/supervisor.d/*.ini /etc/supervisor.d/

$ ./wsl2/bin/supervisorctl update
```

### 3. 启动组件

```powershell
$ ./wsl2/bin/supervisorctl start kube-node:flanneld
$ ./wsl2/bin/supervisorctl start kube-node:kube-proxy
$ ./wsl2/bin/supervisorctl start kube-node:kube-containerd

# 启动 kubelet 必须先进行初始化
$ ./wsl2/kubelet init
$ ./wsl2/bin/supervisorctl start kube-node:kubelet

# 或者可以直接启动全部组件
$ ./wsl2/kubelet init
$ ./wsl2/bin/supervisorctl start kube-node:
```

## 4. 信任证书

```bash
$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig get csr

$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig certificate approve csr-d6ndc
```

## 5. kubectl

```powershell
# $ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig

# 封装上边的命令
$ ./wsl2/bin/kubectl
```

## 6. crictl

```powershell
$ ./wsl2/bin/crictl
```

## 组件启动方式总结

启动组件有三种方式,下面以 `kube-proxy` 组件为例,其他组件同理

```powershell
# 会占据窗口
$ ./wsl2/kube-proxy start
```

```powershell
# 对 wsl -u root -- supervisorctl 命令的封装
$ ./wsl2/bin/supervisorctl start kube-node:kube-proxy
```

```powershell
# 对上一条命令的封装
$ ./wsl2/kube-proxy start -d
```

## 一键启动

**一键启动之前必须保证 [kube-server](README.SERVER.md) 正常运行**

**生成配置并进行 kubelet 初始化**

```powershell
$ ./wsl2/bin/supervisorctl g

$ ./wsl2/bin/supervisorctl update

$ ./wsl2/kubelet init
```

之后一键启动

```powershell
$ ./wsl2/bin/supervisorctl start kube-node:

# $./wsl2/bin/supervisorctl status kube-node:
```

## 最终脚本(日常使用)

```powershell
$ ./wsl2/bin/kube-node
```

## 命令封装

为避免 Windows 与 WSL 切换和执行 WSL 命令时加上 `$ wsl -u root -- XXX` 的繁琐,特封装了部分命令以便于直接在 Windows 上执行,具体请查看 `./wsl2/bin/*`

## 参考

```powershell
# 相当于关闭虚拟机
$ wsl --shutdown
```

kubelet 出错

```bash
$ wsl -u root -- rm -rf ${K8S_ROOT:-/opt/k8s}/conf/kubelet-bootstrap.kubeconfig
```

* https://github.com/kubernetes-sigs/kind/blob/master/site/content/docs/user/using-wsl2.md
