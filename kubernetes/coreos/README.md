# Deploy Kubernetes on CoreOS

* [生成 Docker Daemon 远程连接自签名证书文件](https://www.khs1994.com/docker/dockerd.html)

## Overview

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/coreos.svg?style=social&label=Stars)](https://github.com/khs1994-docker/coreos) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/coreos.svg)](https://store.docker.com/community/images/khs1994/coreos) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/coreos.svg)](https://store.docker.com/community/images/khs1994/coreos)

### 技能储备

* VirtualBox 或其他虚拟机的使用方法

* systemd

* Docker

* Kubernetes

## Usage

* 安装 CoreOS 详细教程请查看：https://www.khs1994.com/categories/Docker/CoreOS/ `硬盘安装 CoreOS 三节点集群`

## 注意事项

* 若使用虚拟机安装，建议电脑内存 **16G** 硬盘 **100G** 可用空间。

### 虚拟机网络配置

VirtualBox 增加 hostonly 网络 **192.168.57.1** 网段

### 下载相关文件

```bash
# download coreos iso files
$ ./coreos init

# download kubernetes server files
$ cd ..
$ ./lnmp-k8s kubernetes-server
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

* https://www.khs1994.com/categories/Docker/CoreOS/ `硬盘安装 CoreOS 三节点集群`

```bash
# create VirtualBox vm
$ ./coreos new-vm N

# 在管理界面打开设置，按照实际进行微调，之后保存
# then start node, exec this command in node console

$ export LOCAL_HOST=192.168.57.1

$ curl ${LOCAL_HOST}:8080/disk/bin/coreos.sh > coreos.sh

$ sh coreos.sh { 1 | 2 | 3 | n | test | one }
```

## 虚拟机网卡设置

| 网卡    | 模式                  | IP              |
| :----- | :-------------        |:------          |
| 网卡1   | `host-only` (静态IP)  | `192.168.57.*`  |
| 网卡2   | 桥接 (`DHCP`)         | `192.168.199.*` |

## Windows Hyper-V 固定 IP

* https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/nested-virtualization

```bash
$ New-VMSwitch -Name k8s -SwitchType Internal

$ New-NetIPAddress -IPAddress 192.168.57.1 -PrefixLength 24 -InterfaceIndex 24

$ New-NetNat –Name LocalNAT –InternalIPInterfaceAddressPrefix 192.168.57.1/24

$ Get-NetAdapter "vEthernet (k8s)" | New-NetIPAddress -IPAddress 192.168.57.1 -AddressFamily IPv4 -PrefixLength 24

# windows client network settings

# $ Get-NetAdapter "Ethernet" | New-NetIPAddress -IPAddress 192.168.100.2 -DefaultGateway 192.168.100.1 -AddressFamily IPv4 -PrefixLength 24

# $ Netsh interface ip add dnsserver “Ethernet” address=<my DNS server>
```

```bash
$ sudo vi /etc/systemd/network/30-static.network

[Match]
Name=eth0

[Network]
Address=IP_1/24
DNS=114.114.114.114
Gateway=192.168.57.1

$ sudo systemctl restart systemd-networkd
```

# More Information

* https://github.com/coreos/coreos-kubernetes

* https://github.com/opsnull/follow-me-install-kubernetes-cluster

* https://github.com/Mengkzhaoyun/ansible

* https://github.com/coreos/container-linux-config-transpiler

* https://github.com/coreos/container-linux-config-transpiler/blob/master/doc/configuration.md

* http://www.cnblogs.com/mengkzhaoyun/p/7599695.html

* https://coreos.com/os/docs/latest/generate-self-signed-certificates.html

* https://github.com/cloudflare/cfssl
