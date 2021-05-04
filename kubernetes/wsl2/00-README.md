# WSL2 Kubernetes 节点

## 注意事项

* `wsl2.k8s.khs1994.com` 解析到 WSL2 IP
* `windows.k8s.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443` `windows.k8s.khs1994.com:16443(netsh 代理)`
* 新建 `wsl-k8s` WSL 发行版用于 k8s 运行，`wsl-k8s-data`（可选） WSL 发行版用于存储数据
* 问题1: WSL2 暂时不能固定 IP,每次重启必须执行 `$ kubectl certificate approve csr-XXXX`
* WSL2 IP 变化时必须重新执行 `./kube-wsl2windows k8s`
* WSL2 **不要** 自定义 DNS 服务器(/etc/resolv.conf)
* 与 Docker 桌面版启动的 dockerd on WSL2 冲突，请停止并执行 `$ wsl --shutdown` 后使用本项目

## master

`etcd` `kube-apiserver` `kube-controller-manager` `kube-scheduler`

以上软件部署请参考 [kube-server](00-README.SERVER.md)

## 自定义 WSL2 内核

请查看 [README.KERNEL.md](README.KERNEL.md)

## 设置 PATH

```bash
$ wsl -d wsl-k8s

$ vim ~/.bashrc

export PATH=/wsl/wsl-k8s-data/k8s/bin:$PATH
```

## 复制文件

```bash
$ wsl -d wsl-k8s

$ set -x
$ source ./wsl2/.env

$ mkdir -p ${K8S_ROOT:?err}/bin
$ cp -a kubernetes-release/release/v1.21.0-linux-amd64/kubernetes/server/bin/{kube-proxy,kubectl,kubelet,kubeadm,mounter} ${K8S_ROOT:?err}/bin
```

在 `Windows` 中执行

```powershell
$ $items="kubelet.config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","etcd-client.pem","etcd-client-key.pem","ca.pem","ca-key.pem"

$ foreach($item in $items){cp ./wsl2/certs/$item systemd/certs}
```

## join

```bash
$ wsl -d wsl-k8s

$ debug=1 ./lnmp-k8s join 127.0.0.1 --containerd --skip-cp-k8s-bin
```

## 启动 K8S

请查看 [00-README.systemd.md](00-README.systemd.md)

## kubectl

请查看 [00-README.kubectl.md](00-README.kubectl.md)

## crictl

```powershell
$ import-module ./wsl2/bin/WSL-K8S.psm1

$ invoke-crictl
```
