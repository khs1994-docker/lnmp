# 树莓派运行 k8s 节点

## 注意事项

* 本例将 `WSL2` 作为 kube-server 节点,请参考 [WSL2 kube-server](../wsl2/README.SERVER.md)
* 树莓派 固定 IP `本文以 192.168.199.101 为例`
* 由于树莓派只有 `1G` 内存,故 k8s 组件能不放到树莓派就不放到树莓派,组件运行环境查看下方列表

## Node `树莓派` `192.168.199.101`

* `containerd`
* `kubelet`
* `kube-proxy`

## 传输文件到树莓派

```powershell
# 下载 k8s
$ wsl -- ./lnmp-k8s kubernetes-server linux arm64 node

$ $items="kubelet.config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","etcd-client.pem","etcd-client-key.pem"

$ foreach($item in $items){scp ./wsl2/certs/$item pi@192.168.199.101:/home/pi/lnmp/kubernetes/systemd/certs}

$ $items="kube-proxy","kubelet","kubectl","kubeadm","mounter"

$ foreach($item in $items){scp ./kubernetes-release/release/v1.18.0-linux-arm64/kubernetes/server/bin/$item pi@192.168.199.101:/home/pi/}
```

## 升级 libseccomp2 到 [2.4.x](https://packages.debian.org/bullseye/libseccomp2)

* https://github.com/containerd/containerd/issues/3871

```bash
$ curl -L -O http://ftp.cn.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.4.3-1+b1_arm64.deb

$ curl -L -O https://mirrors.ustc.edu.cn/debian/pool/main/libs/libseccomp/libseccomp-dev_2.4.3-1+b1_arm64.deb

$ sudo dpkg -i libseccomp2_2.4.3-1+b1_arm64.deb libseccomp-dev_2.4.3-1+b1_arm64.deb

# 测试
$ /opt/k8s/bin/kube-containerd -v
```

## 登录到树莓派

```bash
$ cd ~/lnmp/kubernetes

# 编辑 `systemd/.env`

KUBE_APISERVER=https://192.168.199.100:16443

$ ./lnmp-k8s join 192.168.199.101 --containerd --skip-cp-k8s-bin
# 上边命令会下载 crictl 等

$ sudo cp ~/kube{-proxy,let,ctl,adm} /opt/k8s/bin

$ sudo chmod +x /opt/k8s/bin/kube{-proxy,let,ctl,adm}
```

启动组件

```bash
$ sudo systemctl start kube-proxy

$ sudo systemctl start kube-containerd

$ sudo systemctl start kubelet
```

## 信任证书

```bash
$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig get csr

$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig certificate approve csr-XXXXX
```

## 部署 CNI -- calico

```bash
$ kubectl apply -k addons/cni/calico-custom
```

> 若不能正确匹配网卡，请修改 `calico.yaml` 文件中 `IP_AUTODETECTION_METHOD` 变量的值

## kubectl

```bash
# $ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig

# 封装上边的命令
$ ./wsl2/bin/kubectl
```
