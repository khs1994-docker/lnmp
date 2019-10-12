# 树莓派运行 k8s 节点

## 注意事项

* 本例将 `WSL2` 作为 kube-server 节点,请参考 [WSL2 kube-server](../wsl2/README.SERVER.md)
* 树莓派 固定 IP `192.168.199.101`
* 由于树莓派只有 `1G` 内存,故 k8s 组件能不放到树莓派就不放到树莓派,组件运行环境查看下方列表

## Node `树莓派` `192.168.199.101`

* `flanneld`
* `containerd`
* `kubelet`
* `kube-proxy`

## 传输文件到树莓派

```powershell
$ $items="kubelet-config.yaml","kube-proxy.config.yaml","csr-crb.yaml","kubectl.kubeconfig","kube-proxy.kubeconfig","flanneld.pem","flanneld-key.pem"

$ foreach($item in $items){scp ./wsl2/certs/$item pi@192.168.199.101:/home/pi/lnmp/kubernetes/systemd/certs}

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

启动组件

```bash
$ sudo systemctl start flanneld

$ sudo systemctl start kube-proxy

$ sudo systemctl start kube-containerd

$ sudo systemctl start kubelet
```

## 信任证书及 kubectl

```bash
$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig get csr

$ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig certificate approve csr-d6ndc
```
