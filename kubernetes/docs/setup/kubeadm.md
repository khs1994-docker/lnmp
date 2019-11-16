# kubeadm 部署 kubernetes(基于 1.16.x)

* https://github.com/kubernetes/kubeadm

* https://docs.khs1994.com/feiskyer-kubernetes-handbook/deploy/kubeadm.html
* https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/

## 准备

master 节点安装 **kubelet** **kubeadm** **kubectl**

> 手动下载二进制文件放入 PATH，或者使用包管理工具安装。下面介绍如何使用包管理工具安装

### Ubuntu/Debian

```bash
$ apt-get update && apt-get install -y apt-transport-https
$ curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

$ cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

$ apt-get update
$ apt-get install -y kubelet kubeadm kubectl
```

### CentOS/Fedora

```bash
$ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

$ setenforce 0
$ sudo yum install -y kubelet kubeadm kubectl
```

## 部署

### 修改 `kubelet.service` (使用包管理工具安装 kubeadm 请跳过此步)

```bash
$ sudo mkdir -p /etc/systemd/system/kubelet.service.d

$ sudo vim /etc/systemd/system/kubelet.service.d/kubeadm.conf
```

写入以下内容

```bash
[Service]
ExecStart=
ExecStart=/usr/bin/kubelet \
--pod-infra-container-image=gcr.azk8s.cn/google-containers/pause:3.1 \
--cgroup-driver=systemd \
--pod-manifest-path=/etc/kubernetes/manifests \
--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf \
--kubeconfig=/etc/kubernetes/kubelet.conf \
--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin \
--cluster-dns=10.96.0.10 --cluster-domain=cluster.local \
--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt \
--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki
```

应用配置

```bash
$ sudo systemctl daemon-reload
```

### 开始部署

#### master

```bash
$ sudo kubeadm init --image-repository gcr.azk8s.cn/google-containers \
      --v 5 \
      --node-name=node1 \
      --ignore-preflight-errors=all
```

> 执行可能出现错误，例如缺少依赖包，根据提示安装即可。

执行成功会输出

```bash
...
[addons] Applied essential addon: CoreDNS
I1116 12:35:13.270407   86677 request.go:538] Throttling request took 181.409184ms, request: POST:https://192.168.199.100:6443/api/v1/namespaces/kube-system/serviceaccounts
I1116 12:35:13.470292   86677 request.go:538] Throttling request took 186.088112ms, request: POST:https://192.168.199.100:6443/api/v1/namespaces/kube-system/configmaps
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.199.100:6443 --token cz81zt.orsy9gm9v649e5lf \
    --discovery-token-ca-cert-hash sha256:5edb316fd0d8ea2792cba15cdf1c899a366f147aa03cba52d4e5c5884ad836fe
```

#### node 工作节点

根据提示在 **另一主机** 部署工作节点

```bash
kubeadm join 192.168.199.100:6443 --token cz81zt.orsy9gm9v649e5lf \
    --discovery-token-ca-cert-hash sha256:5edb316fd0d8ea2792cba15cdf1c899a366f147aa03cba52d4e5c5884ad836fe
```

## 高可用

```bash
$ sudo kubeadm join --control-plane 其他参数
```

## flanneld

## 附录

```bash
# /usr/lib/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/

[Service]
ExecStart=/usr/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## kubeadm conf

生成默认的配置文件

```bash
$ kubeadm config print init-defaults
```

```bash
$ kubeadm --config 配置文件名 其他参数
```

## 所需镜像

```bash
$ kubeadm config images list
```

## 笔者总结

* 关键在于配置好 `kubelet`
* k8s 组件除了 `kubelet` 其他组件都能够以 `pod` 方式运行，秘诀在于使用了 `hostnetwork`
* 国内网络问题（拉取不到 `k8s.gcr.io` 镜像）：加上参数 `--image-repository gcr.azk8s.cn/google-containers`
* `kubelet` 的参数 `--cgroup-driver=systemd` 一定要与 Docker 的一致
