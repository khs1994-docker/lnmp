# Deploy Kubernetes on Fedora CoreOS（FCOS）

## Overview

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/coreos.svg?style=social&label=Stars)](https://github.com/khs1994-docker/coreos) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/coreos.svg)](https://hub.docker.com/r/khs1994/coreos) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/coreos.svg)](https://hub.docker.com/r/khs1994/coreos)

### 技能储备

* VirtualBox（6.x）或其他虚拟机的使用方法
* systemd
* Docker
* Kubernetes

## Usage

## 注意事项

* 若使用虚拟机安装，建议电脑内存 **16G** 硬盘 **100G** 可用空间
* bug1: ignition 不能有 `storage.directories` 指令
* bug2: 硬盘空间充足，但报硬盘空间不足错误，解决办法: ignition `storage.files.path` 不要列出大文件
* `SELinux` 已关闭
* `kubelet` 容器运行时为 `containerd`，可以改为 `docker`
* `Etcd` `kube-nginx` 运行方式为 `podman`
* bug3: 异常关机（强制关机）可能导致 `podman` 运行出错，请删除镜像之后重启服务

### 虚拟机网络配置

> VirtualBox 增加 hostonly 网络 **192.168.57.1** 网段:

```bash
# 首次使用执行两次，保证存在 vboxnet1 网卡，到 VirtualBox -> 管理 -> 主机网络管理器 查看
$ VBoxManage hostonlyif create

$ VBoxManage hostonlyif ipconfig vboxnet1 --ip 192.168.57.1 --netmask 255.255.255.0
```

VirtualBox -> 管理 -> 主机网络管理器 -> vboxnet1 -> 启用 DHCP 服务器（右边）

### 下载相关文件

```bash
# download coreos iso files
$ ./coreos init
```

如果下载缓慢可以替换 `hosts`,具体参考 `khs1994-docker/lnmp` 的 `config/etc/hosts`

```bash
$ cd ..
# download kubernetes server files
$ ./lnmp-k8s kubernetes-server

# download soft
$ items="etcd cni flanneld helm crictl containerd"
$ items="flanneld helm crictl containerd"
$ for item in $items;do ./lnmp-k8s _${item}_install --dry-run;done
```

### 修改 .env 文件

自行调整配置

### 自行配置 `ignition-n.yaml`

本项目默认支持 **3** 节点，如果你要增加节点，请进行如下操作

`n` 为节点数

```bash
$ ./coreos add-node {n} [TYPE:master | node]# n > 3
```

### 启动本地服务器

```bash
$ ./coreos server
```

### 安装 CoreOS

```bash
# create VirtualBox vm
# 安装第一个节点 N 为 1，以此类推
$ ./coreos new-vm N

# 在管理界面打开虚拟机设置
# 1.不要勾选 系统 -> 启用EFI
# 启动虚拟机，在终端执行以下命令

$ export SERVER_HOST=192.168.57.1

# 节点 1 设置 NODE_NAME 为 1，以此类推
$ curl ${SERVER_HOST}:8080/bin/coreos.sh | NODE_NAME=1 bash

# 关机，在虚拟机设置页面
# 1.系统 -> 启用 EFI
# 重新启动
```

## 测试三节点集群

三节点全部启动之后，集群才能正常运行！

## 虚拟机网卡设置

| 网卡    | 模式                  | IP              |
| :----- | :-------------        |:------          |
| 网卡1   | 桥接 (`DHCP`)         | `192.168.199.*`(根据实际配置) |
| 网卡2   | `host-only` (静态IP)  | `192.168.57.*`  |

# More Information

* https://blog.khs1994.com/categories/Docker/CoreOS/
* [生成 Docker Daemon 远程连接自签名证书文件](https://blog.khs1994.com/docker/dockerd.html)
* https://github.com/coreos/coreos-kubernetes
* https://github.com/opsnull/follow-me-install-kubernetes-cluster
* https://github.com/Mengkzhaoyun/ansible
* https://github.com/coreos/container-linux-config-transpiler
* https://github.com/coreos/container-linux-config-transpiler/blob/master/doc/configuration.md
* http://www.cnblogs.com/mengkzhaoyun/p/7599695.html
* https://coreos.com/os/docs/latest/generate-self-signed-certificates.html
* https://github.com/cloudflare/cfssl
* https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/
* https://github.com/coreos/coreos-installer/
* https://github.com/coreos/fcct
