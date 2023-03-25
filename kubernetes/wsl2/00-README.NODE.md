# WSL2 Kubernetes 节点

## 注意事项

* `wsl2.k8s.khs1994.com` 解析到 WSL2 IP
* `windows.k8s.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443` `windows.k8s.khs1994.com:16443(netsh 代理)`
* 新建 `wsl-k8s` WSL2 发行版用于 k8s 运行，`wsl-k8s-data`（可选） WSL2 发行版用于存储数据
* 问题1: WSL2 暂时不能固定 IP,每次重启必须执行 `$ kubectl certificate approve csr-XXXX`
* WSL2 IP 变化时必须重新执行 `./kube-wsl2windows k8s`
* WSL2 **不要** 自定义 DNS 服务器(不要自行编辑 /etc/resolv.conf)
* 本项目与 **Docker 桌面版** 冲突，请先停止 **Docker 桌面版** 并执行 `$ wsl --shutdown` 后使用本项目

## master

`etcd` `kube-apiserver` `kube-controller-manager` `kube-scheduler`

以上软件部署请参考 [kube-server](00-README.SERVER.md)

## 自定义 WSL2 内核

请查看 [README.KERNEL.md](README.KERNEL.md)

## SWAP 设置为 0

```bash
# Windows 中 ~/.wslconfig
[wsl2]
swap=0
```

## 设置 PATH

```powershell
$ wsl -d wsl-k8s -- bash -cx 'vim ~/.bashrc'

export PATH=/wsl/wsl-k8s-data/k8s/bin:$PATH
```

## 启用 systemd

请查看 [00-README.systemd.init.md](00-README.systemd.init.md)

## 复制文件

```powershell
$ ./wsl2/bin/kube-check

$env:WSLENV="K8S_ROOT/u"
$env:K8S_ROOT="/wsl/wsl-k8s-data/k8s"

$ wsl -d wsl-k8s -- sh -xc 'mkdir -p ${K8S_ROOT:?err}/bin'
# 请将 1.26.0 替换为实际的版本号
$ wsl -d wsl-k8s -- bash -xc 'cp -a kubernetes-release/release/v1.26.0-linux-amd64/kubernetes/server/bin/{kube-proxy,kubectl,kubelet,kubeadm,mounter} ${K8S_ROOT:?err}/bin'

$ $items="kubelet.config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","etcd-client.pem","etcd-client-key.pem","ca.pem","ca-key.pem"

$ foreach($item in $items){cp \\wsl$\wsl-k8s\wsl\wsl-k8s-data\k8s\etc\kubernetes\pki\$item systemd/certs}

$items="kubectl.kubeconfig","etcd-client.pem","etcd-client-key.pem","ca.pem","ca-key.pem","admin.pem","admin-key.pem"

$ foreach($item in $items){cp \\wsl$\wsl-k8s\wsl\wsl-k8s-data\k8s\etc\kubernetes\pki\$item wsl2/certs}
```

## join

```powershell
$ wsl -d wsl-k8s -- sh -xc 'debug=1 ./lnmp-k8s join 127.0.0.1 --containerd --skip-cp-k8s-bin'
```

## 启动 K8S

请查看 [02-README.systemd.md](02-README.systemd.md)

## 部署组件

请查看 [01-README.addons.md](01-README.addons.md)

## kubectl

在 `WSL2` 中执行

```bash
$ wsl -d wsl-k8s

$ kubectl
```

在 `Windows` 中执行

```powershell
$ ./wsl2/bin/kubectl-config-set-cluster

$ kubectl
```

## crictl

在 `WSL2` 中执行

```bash
$ wsl -d wsl-k8s

$ crictl
```

在 `Windows` 中执行

```powershell
$ import-module ./wsl2/bin/WSL-K8S.psm1

$ invoke-crictl
```
