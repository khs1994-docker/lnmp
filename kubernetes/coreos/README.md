# Deploy Kubernetes on [Fedora CoreOS（FCOS）](https://getfedora.org/en/coreos/download/?tab=metal_virtualized&stream=next)

## Overview

### 技能储备

* VirtualBox（6.x）或其他虚拟机的使用方法
* systemd
* Docker
* Kubernetes

## Usage

## virtualbox 国内镜像地址

* https://mirror.tuna.tsinghua.edu.cn/help/virtualbox/

## 注意事项

* 虚拟机内存 `3072M (3G)`，设置为 `2048M (2G)` 将无法启动
* 若使用虚拟机安装，建议电脑内存 **16G** 硬盘 **100G** 可用空间
* `SELinux` 已关闭
* `kubelet` 容器运行时为 `containerd`，可以改为 `docker`
* `Etcd` `kube-nginx` 等部分服务运行方式为 `podman`
* **bug:** 硬盘空间充足，但报硬盘空间不足错误，解决办法: ignition `storage.files.path` 不要列出大文件
* **bug:** 异常关机（强制关机）可能导致 `podman` 运行出错，请删除镜像 `(例如：$ sudo podman rmi IMAGE_NAME)` 之后重启服务 `(例如：$ sudo systemctl restart etcd)`

### 虚拟机网络配置

> VirtualBox 增加 **hostonly** 网络 **192.168.57.1** 网段(vboxnet1 网卡)、**192.168.58.1** 网段(vboxnet2 网卡),并启用 DHCP:

```bash
# 首次使用执行两次，保证存在 vboxnet1、vboxnet2 网卡（在 VirtualBox -> 管理 -> 主机网络管理器 查看）
$ VBoxManage hostonlyif create

$ VBoxManage hostonlyif ipconfig vboxnet1 --ip 192.168.57.1 --netmask 255.255.255.0 --dhcp
$ VBoxManage hostonlyif ipconfig vboxnet2 --ip 192.168.58.1 --netmask 255.255.255.0 --dhcp
```

### 下载相关文件

```bash
# download coreos iso files
$ ./coreos init
```

如果下载缓慢可以替换 `hosts`,具体参考 `khs1994-docker/lnmp` 的 `config/etc/hosts`

```bash
$ cd ..
# ~/lnmp/kubernetes

# download kubernetes server files
$ ./lnmp-k8s kubernetes-server

# $ ./lnmp-k8s kubernetes-server --url

# download soft
# $ items="etcd cni crictl containerd"
$ items="crictl containerd"
$ for item in $items;do ./lnmp-k8s _${item}_install --dry-run;done
```

### 修改 .env 文件

自行调整配置

### 自行配置 `ignition-n.bu`

本项目默认支持 **3** 节点，如果你要增加节点，请进行如下操作

`n` 为节点数,必须大于 **3**

```bash
$ ./coreos add-node {n} [TYPE:master | node] # n > 3
```

### 启动本地服务器

```bash
$ docker pull khs1994/fcos

$ ./coreos server
```

### 安装 CoreOS

```bash
# create VirtualBox vm
# 安装第一个节点 N 为 1，以此类推
$ ./coreos new-vm N

# 启动虚拟机，在终端执行以下命令

$ export SERVER_HOST=192.168.57.1

# 节点 1 设置 NODE_NAME 为 1，以此类推
$ curl ${SERVER_HOST}:8080/bin/coreos.sh | NODE_NAME=1 bash

# 关机
$ poweroff

# 在虚拟机设置页面移除 ISO
# 存储 -> 存储介质 -> 选住 ISO -> 属性 -> 移除虚拟盘 点击确定
# 或者执行
$ ./coreos umount-iso N
$ ./coreos mount-iso N

# 重新启动(可能会遇到异常，只要不是 ignition 错误，强制重启即可)
```

## 测试三节点集群

三节点全部启动之后，集群才能正常运行！

* `192.168.57.110`
* `192.168.57.111`
* `192.168.58.112`

**安装 ipset (否则将不能启用 IPVS 模式)**

每个节点都安装之后重启

```bash
$ sudo rpm-ostree install ipset
```

**修改 .kube 权限**

```bash
$ sudo chown -R core:core ~/.kube
```

**部署 CNI -- calico**

```bash
$ kubectl apply -f /home/core/calico.yaml
```

## 测试 k8s 集群功能

## 附录

**虚拟机网卡设置**

| 网卡    | 模式                  | IP              |
| :-----  | :-------------        |:------          |
| 网卡1   | `host-only` (静态IP)  | `192.168.57.*`  |
| 网卡2   | 桥接 (`DHCP`)         | `192.168.199.*`(根据实际配置) |

**添加默认路由**

有时可能连接不到网络，请添加路由（`192.168.199.1` 为桥接网络的网关地址）。

```bash
$ sudo route add default gw 192.168.199.1
```

## More Information

* [生成 Docker Daemon 远程连接自签名证书文件](https://blog.khs1994.com/docker/dockerd.html)
* https://github.com/coreos/coreos-kubernetes
* https://github.com/opsnull/follow-me-install-kubernetes-cluster
* https://github.com/Mengkzhaoyun/ansible
* https://github.com/coreos/butane/blob/master/docs/config-fcos-v1_1.md
* https://www.cnblogs.com/mengkzhaoyun/p/7599695.html
* https://github.com/cloudflare/cfssl
* https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/
* https://github.com/coreos/coreos-installer/
