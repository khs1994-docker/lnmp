# WSL2 Kubernetes 节点 ($ ./wsl2/bin/kube-node)

## 注意事项

* `wsl2.lnmp.khs1994.com` 解析到 WSL2 IP
* `windows.lnmp.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.lnmp.khs1994.com:6443` `windows.lnmp.khs1994.com:16443(kube-nginx 代理)`
* 新建 `k8s-data` WSL 发行版用于存储数据
* 问题1: WSL2 暂时不能固定 IP,每次重启必须执行 `$ kubectl certificate approve csr-XXXX`
* WSL2 IP 变化时必须重启 `kube-nginx`
* WSL2 `Ubuntu-18.04` 设为默认 WSL
* WSL2 **不要** 自定义 DNS 服务器(/etc/resolv.conf)
* 由于缺少文件 `kube-proxy` 不能使用 `ipvs` 模式,解决办法请查看 [编译 WSL2 内核](README.KERNEL.md)
* 接下来会一步一步列出原理,日常使用请查看最后的 **最终脚本 ($ ./wsl2/bin/kube-node)**

## master

`etcd` `kube-apiserver` `kube-controller-manager` `kube-scheduler`

以上节点请参考 [kube-server](README.SERVER.md)

## node

### 设置 PATH

```bash
$ vim ~/.bashrc

export PATH=/wsl/k8s-data/k8s/bin:$PATH
```

### 复制文件

```bash
$ wsl

$ set -x
$ source ./wsl2/.env

$ sudo mkdir -p ${K8S_ROOT:?err}/bin
$ sudo cp -a kubernetes-release/release/v1.16.1-linux-amd64/kubernetes/server/bin/kube{-proxy,ctl,let,adm} ${K8S_ROOT:?err}/bin
```

在 `Windows` 中执行

```powershell
$ $items="kubelet.config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","flanneld.pem","flanneld-key.pem"

$ foreach($item in $items){cp ./wsl2/certs/$item systemd/certs}
```

### join

```bash
$ wsl

$ ./lnmp-k8s join 127.0.0.1 --containerd --skip-cp-k8s-bin
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

在 WSL2 安装配置 `supervisor` 请参考 [kube-server](README.SERVER.md)

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

NAME        AGE    REQUESTOR                 CONDITION
csr-4njmh   2d2h   system:node:wsl2          Pending

$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig certificate approve CSR_NAME(csr-4njmh)
```

## 5. kubectl

将 WSL2 K8S 配置写入 `~/.kube/config`

```bash
$ ./wsl2/bin/kubectl-config-set-cluster
```

或者 **通过参数** 加载配置文件

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

## 添加 hosts

```bash
NODE_IP NODE_NAME

# x.x.x.x wsl2
```

或者执行脚本 `./wsl2/bin/wsl2host [ --write ]` 需要管理员权限

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

## 命令封装

为避免 Windows 与 WSL 切换和执行 WSL 命令时加上 `$ wsl -u root -- XXX` 的繁琐,特封装了部分命令以便于直接在 Windows 上执行,具体请查看 `./wsl2/bin/*`

## WSL2 IP 变化造成的 kubelet 报错

```bash
certificate_manager.go:464] Current certificate is missing requested IP addresses [172.21.21.166]
```

* 每次 IP 变化时删除 `${K8S_ROOT}/certs/kubelet-server-*.pem` 证书.

## 最终脚本(日常使用)

> 脚本 **需要** 管理员权限(弹出窗口,点击确定)写入 wsl2hosts 到 `C:\Windows\System32\drivers\etc\hosts`

```powershell
$ ./wsl2/bin/kube-node

# $ ./wsl2/bin/kube-node stop
```

由于 WSL2 IP 不能固定, 每次重启时 **必须** 签署 kubelet 证书:

```bash
# 获取 csr
$ ./wsl2/bin/kubectl-get-csr

NAME        AGE   REQUESTOR          CONDITION
csr-9pvrm   11m    system:node:wsl2          Pending
```

根据提示 **签署** 证书,一般为最后一个

```bash
$ ./wsl2/bin/kubectl certificate approve csr-9pvrm
```

如果使用 NFS 卷

启动 NFS 服务端容器

```bash
$ sudo service docker start

$ ./lnmp-k8s nfs
```
