# kubeadm 部署 kubernetes

* https://github.com/kubernetes/kubeadm

* https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
* https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/
* https://docs.khs1994.com/feiskyer-kubernetes-handbook/deploy/kubeadm.html
* https://blog.csdn.net/tiger435/article/details/85002337

## 安装 **kubelet** **kubeadm** **kubectl**

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

## 修改内核的运行参数

* https://kubernetes.io/docs/setup/production-environment/container-runtimes/

```bash
$ sysctl -a | grep net.*iptables

net.bridge.bridge-nf-call-iptables = 1
# 若未输出以上结果，请执行以下命令，若正常输出，请跳过以下命令

$ cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# 应用配置
$ sysctl --system
```

## 配置 kubelet

### 修改 `kubelet.service` (使用包管理工具安装 kubeadm 请跳过此步，查看下一步骤)

```bash
$ sudo mkdir -p /etc/systemd/system/kubelet.service.d
```

`/etc/systemd/system/kubelet.service.d/10-kubeadm.conf` 写入以下内容(内容来自包管理工具安装的 kubeadm)

```bash
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/sysconfig/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
```

`/etc/systemd/system/kubelet.service.d/10-proxy-ipvs.conf` 写入以下内容

```bash
# 启用 ipvs 相关内核模块，用于 kube-proxy
[Service]
ExecStartPre=-modprobe ip_vs
ExecStartPre=-modprobe ip_vs_rr
ExecStartPre=-modprobe ip_vs_wrr
ExecStartPre=-modprobe ip_vs_sh
```

`/etc/systemd/system/kubelet.service` 写入以下内容

```bash
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/home/

[Service]
ExecStart=/usr/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 应用配置

$ sudo systemctl daemon-reload
```

### 修改 `kubelet.service` (使用包管理工具安装 kubeadm)

`/etc/systemd/system/kubelet.service.d/10-proxy-ipvs.conf` 写入以下内容

```bash
# 启用 ipvs 相关内核模块，用于 kube-proxy
[Service]
ExecStartPre=-modprobe ip_vs
ExecStartPre=-modprobe ip_vs_rr
ExecStartPre=-modprobe ip_vs_wrr
ExecStartPre=-modprobe ip_vs_sh
```

```bash
# 应用配置

$ sudo systemctl daemon-reload
```

## 部署

### master

```bash
$ sudo kubeadm init --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers \
      --pod-network-cidr 10.244.0.0/16 \
      --v 5 \
      --ignore-preflight-errors=all
```

* `--pod-network-cidr 10.244.0.0/16` 参数与后续 CNI 插件有关，这里以 `calico` 为例，若后续部署其他类型的网络插件请更改此参数。
* 使用 **配置文件** 的方式这里不再赘述

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

### node 工作节点

在 **另一主机** 重复 **部署** 小节以前的步骤，安装配置好 kubelet。根据提示，加入到集群。

```bash
$ kubeadm join 192.168.199.100:6443 --token cz81zt.orsy9gm9v649e5lf \
    --discovery-token-ca-cert-hash sha256:5edb316fd0d8ea2792cba15cdf1c899a366f147aa03cba52d4e5c5884ad836fe
```

## 使用

将 `/etc/kubernetes/admin.conf` 复制到 `~/.kube/config`

执行 `$ kubectl get all -A`

由于未部署 CNI 插件，CoreDNS 未正常启动。

## 部署 CNI -- calico

* https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/

修改 `addons/cni/calico/configMap.yaml` 中的 `192.168.0.0/16` 为 `10.244.0.0/16`(同 `flannel` 一致)

有 [三种方式](https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/) 存储 calico 数据,这里采用第一种 `Installing with the Kubernetes API datastore—50 nodes or less`

#### 修改内核参数

`/etc/sysctl.d/99-kubernetes-calico.conf` 写入以下内容

```bash
net.ipv4.conf.all.rp_filter = 1
```

> Fedora 31 默认值为 2 ,其他系统通过 `sysctl -a | grep net.ipv4.conf.all.rp_filter` 查看

```bash
# 应用配置

$ sysctl --system
```

不进行以上步骤的话,会报如下错误

```bash
2019-11-17 03:23:02.084 [FATAL][5336] int_dataplane.go 1032: Kernel's RPF check is set to 'loose'.  This would allow endpoints to spoof their IP address.  Calico requires net.ipv4.conf.all.rp_filter to be set to 0 or 1. If you require loose RPF and you are not concerned about spoofing, this check can be disabled by setting the IgnoreLooseRPF configuration parameter to 'true'.
```

#### 部署

```bash
$ kubectl apply -k addons/cni/calico
```

## kube-proxy

* https://github.com/kubernetes/kubernetes/blob/master/pkg/proxy/ipvs/README.md

启用 `ipvs` 模式

```bash
$ kubectl edit cm kube-proxy -n kube-system
```

```diff
- mode: ""
+ mode: "ipvs"
```

加载内核模块(手动加载，实际上已通过 systemd 的配置执行了加载命令，这里介绍一下原理)

```bash
# 根据 kube-proxy 日志，查看未加载模块
$ E1116 12:53:34.421604       1 server_others.go:339] can't determine whether to use ipvs proxy, error: IPVS proxier will not be used because the following required kernel modules are not loaded: [ip_vs_rr ip_vs_wrr ip_vs_sh]

$ modprobe -- ip_vs
$ modprobe -- ip_vs_rr
$ modprobe -- ip_vs_wrr
$ modprobe -- ip_vs_sh

$ modprobe -- nf_conntrack_ipv4
# linux 内核 4.19+
$ modprobe -- nf_conntrack
```

开机自动加载内核模块(Ubuntu)

```bash
$ cat <<EOF | sudo tee /etc/modules
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
EOF
```

CentOS 系列请参考 https://blog.csdn.net/s1234567_89/article/details/51836344

重启 `kube-proxy` (注意将 XXX 替换为自己的名称)

```bash
$ kubectl get pod -n kube-system

$ kubectl get pod/kube-proxy-XXX -n kube-system -o yaml | kubectl replace --force -f -
```

## master 节点默认不能运行 pod

* https://blog.csdn.net/BigData_Mining/article/details/88683459

也就是说如果用 `kubeadm` 部署一个单节点集群不能使用,请执行以下命令

```bash
$ kubectl taint nodes --all node-role.kubernetes.io/master-

# 恢复默认值
# $ kubectl taint nodes NODE_NAME node-role.kubernetes.io/master=true:NoSchedule
```

## 高可用

```bash
$ sudo kubeadm init --apiserver-cert-extra-sans=xxx.com --control-plane-endpoint=xxx.com:6443 其他参数

$ sudo kubeadm join --control-plane 其他参数
```

* 高可用，入口地址不能为 IP(127.0.0.1 NGINX 轮询除外，这里不做介绍) 必须为一个域名,`init` 时必须指定 `--apiserver-cert-extra-sans=xxx.com` `--control-plane-endpoint=xxx.com:6443`。通过 DNS 轮询 xxx.com 实现高可用(请自行搭建 DNS 服务器，这里不做介绍)

## 附录

使用包管理工具安装的 `kubeadm` 增加了哪些文件

```bash
$ yum install yum-utils -y
$ yumdownloader kubeadm
$ rpm2cpio xxx.rpm | cpio -div
```

新增了 `/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf` 文件

```bash
# /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/sysconfig/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
```

## kubeadm 配置文件

* https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2

```bash
# 生成默认的配置文件

$ kubeadm config print init-defaults
```

```bash
# 使用

$ kubeadm init/join --config 配置文件名 其他参数
```

## 所需镜像

```bash
$ kubeadm config images list
```

## 使用其他运行时

`~/lnmp/kubernetes/kubeadm`

## 笔者总结

* 关键在于配置好 `kubelet`
* k8s 组件除了 `kubelet` 其他组件都能够以 `pod` 方式运行，秘诀在于使用了 `hostnetwork`
* 国内网络问题（拉取不到 `k8s.gcr.io` 镜像）：加上参数 `--image-repository registry.cn-hangzhou.aliyuncs.com/google_containers` 解决
* `kubelet` 的参数 `--cgroup-driver=systemd` 一定要与 Docker(或其他的 CRI) 的一致，其他文档有介绍，这里不再赘述
