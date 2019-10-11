# 树莓派运行 k8s

## 注意事项

* Windows 固定 IP `192.168.199.100`
* 树莓派 固定 IP `192.168.199.101`
* `apiServer` 通过 `kube-nginx` 代理到 `https://192.168.199.100:16443`（避免与桌面版 Docker 的 Kubernetes 冲突（6443 端口））
* 由于树莓派只有 `1G` 内存,故 k8s 组件能不放到树莓派就不放到树莓派,组件运行环境查看下方列表
* WSL2 `Ubuntu-18.04` 设为默认 WSL

## 将 `Ubuntu-18.04` 设为版本 2 ,并设置为默认 wsl

```bash
# wsl -h

# 设为默认
$ wsl --set-default Ubuntu-18.04

# 设为版本 2
$ wsl --set-version Ubuntu-18.04 2
```

## 编辑 `.env` `.env.ps1` 文件

* 替换 `192.168.199.100` 为你 Windows 固定 IP

## Master `192.168.199.100`

* `Etcd` Windows
* `kube-apiserver` WSL2
* `kube-controller-manager` WSL2
* `kube-scheduler` WSL2

## Node `树莓派` `192.168.199.101`

* `flanneld`
* `containerd`
* `kubelet`
* `kube-proxy`

## 获取 kubernetes

```bash
$ cd ~/lnmp/kubernetes

$ wsl

$ ./lnmp-k8s kubernetes-server --url
# $ ./lnmp-k8s kubernetes-server

$ ./lnmp-k8s kubernetes-server --url linux arm64
# $ ./lnmp-k8s kubernetes-server linux arm64
```

## 生成证书文件

```bash
$ cd ~/lnmp/kubernetes

$ docker-compose up cfssl-rpi
```

## `WSL2` 文件准备

```bash
$ wsl

$ sudo mkdir -p /opt/k8s/{certs,conf,bin}
$ sudo cp -a rpi/certs /opt/k8s/
$ sudo mv /opt/k8s/certs/*.yaml /opt/k8s/conf
$ sudo mv /opt/k8s/certs/*.kubeconfig /opt/k8s/conf

$ sudo cp -a kubernetes-release/release/v1.16.1-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} \
    /opt/k8s/bin
```

## Windows 启动 Etcd

`lwpm` 安装 Etcd

```bash
$ ./rpi/etcd

$ get-process etcd
```

## Windows 启动 kube-nginx

```bash
$ ./rpi/kube-nginx

$ get-process nginx
```

## Windows 启动 kube-apiserver

```bash
$ ./rpi/kube-apiserver
```

## Windows 启动 kube-controller-manager

```bash
$ ./rpi/kube-controller-manager
```

## Windows 启动 kube-scheduler

```bash
$ ./rpi/kube-scheduler
```

## 传输文件到树莓派

```powershell
$ $items="kubelet-config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","flanneld.pem","flanneld-key.pem"

$ foreach($item in $items){scp ./rpi/certs/$item pi@192.168.199.101:/home/pi/lnmp/kubernetes/systemd/certs}

$ $items="kube-proxy","kubelet","kubectl","kubeadm"

$ foreach($item in $items){scp ./kubernetes-release/release/v1.16.1-linux-arm64/kubernetes/server/bin/$item pi@192.168.199.101:/home/pi/}
```

## 登录到树莓派

```bash
$ cd ~/lnmp/kubernetes

# 编辑 `systemd/.env`

KUBE_APISERVER=https://192.168.199.100:16443

$ ./lnmp-k8s join 192.168.199.101 --containerd --skip-cp-k8s-bin
# 上边命令会下载 flanneld crictl 等

$ sudo cp ~/kube{-proxy,let,ctl,adm} /opt/k8s/bin

$ sudo chmod +x /opt/k8s/bin/kube{-proxy,let,ctl,adm}
```

```bash
$ sudo systemctl start flanneld

$ sudo systemctl start kube-proxy

$ sudo systemctl start kube-containerd

$ sudo systemctl start kubelet
```

## kubectl

```bash
$ kubectl --kubeconfig ./rpi/certs/kubectl.kubeconfig get csr

$ kubectl --kubeconfig ./rpi/certs/kubectl.kubeconfig certificate approve csr-d6ndc
```
