# Deploy Kubernetes on Fedora CoreOS（FCOS）

## Overview

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/coreos.svg?style=social&label=Stars)](https://github.com/khs1994-docker/coreos) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/coreos.svg)](https://store.docker.com/community/images/khs1994/coreos) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/coreos.svg)](https://store.docker.com/community/images/khs1994/coreos)

### 技能储备

* VirtualBox（6.x）或其他虚拟机的使用方法
* systemd
* Docker
* Kubernetes

## Usage

## 注意事项

* 若使用虚拟机安装，建议电脑内存 **16G** 硬盘 **100G** 可用空间。
* bug1: ignition 不能有 `storage.directories` 指令
* bug2: 硬盘空间充足，但报硬盘空间不足错误，解决办法: ignition `storage.files.path` 不要列出大文件
* SELinux 已关闭

### 虚拟机网络配置

> VirtualBox 增加 hostonly 网络 **192.168.57.1** 网段:

VirtualBox -> 管理 -> 主机网络管理器 -> 创建（其 IPv4 网络掩码 **192.168.57.1/24**）（初次配置点击两次创建）(勾选 启用 DHCP)

VirtualBox -> 管理 -> 主机网络管理器 -> 创建（保证 IPv4 网络掩码 **192.168.57.1/24**）（初次配置点击两次创建）

### 下载相关文件

```bash
# download coreos iso files
$ ./coreos init

$ cd ..
# download kubernetes server files
$ ./lnmp-k8s kubernetes-server
# build kube-nginx
$ ./lnmp-k8s _nginx_build
```

### 修改 .env 文件

自行调整配置

### 自行配置 `ignition-n.yaml`

本项目默认支持 **3** 节点，如果你要增加节点，请进行如下操作

`n` 为节点数

```bash
$ ./coreos add-node {n} # n > 3
```

### 启动本地服务器

```bash
$ ./coreos server
```

### 安装 CoreOS

```bash
# create VirtualBox vm
$ ./coreos new-vm N

# 在管理界面打开虚拟机设置
# 1.不要勾选 系统 -> 启用EFI
# 启动虚拟机，在终端执行以下命令

$ export SERVER_HOST=192.168.57.1

# 节点 1 设置 NODE_NAME 为 1，以此类推
$ curl ${SERVER_HOST}:8080/bin/coreos.sh | NODE_NAME=1 bash

# 关机，在虚拟机设置页面
# 1.系统 -> 启用 EFI
# 重新启动。
```

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
