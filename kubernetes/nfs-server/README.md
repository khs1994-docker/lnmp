# NFSv4

> 基于 NFS v4 版本

* https://github.com/ehough/docker-nfs-server
* https://www.cnblogs.com/lykyl/archive/2013/06/14/3136921.html

* https://github.com/khs1994-docker/lnmp/blob/master/docs/volumes/nfs.md

之前本项目默认的 PHP 项目目录为 `./app`，你可以通过设置 `APP_ROOT` 变量来设置 PHP 项目目录。

假设你想要 PHP 项目目录 `app` 与本项目并列那么可以进行如下设置。

```bash
# APP_ROOT="../app"

APP_ROOT="../../app"
```

## 启动 NFS 服务端容器

```bash
# $ lnmp-docker nfs
$ lnmp-k8s nfs
```

## 客户端进行挂载必须安装依赖(重要)

```bash
$ sudo apt install -y nfs-common

$ sudo yum install -y nfs-utils
```

## WSL2

**问题 1:** 在 WSL2 上启动 NFS Server 容器不支持挂载 Windows 路径(例如: `/mnt/c`)

### 编辑 `.env` 文件，挂载路径改为 WSL2 路径

```bash
NFS_DATA_ROOT=/opt/nfs-data
APP_ROOT=/opt/app

# 以上路径均为 WSL2 路径
```

### kube-nginx 代理 2049 端口(必须)

**问题 2:** 由于 WSL2 IP 一直变化, **必须**  通过 `kube-nginx` 代理 WSL2 `2049` 端口到 Windows(IP 固定)

参考 `~/lnmp/kubernetes/wsl2/conf/kube-nginx.conf.temp` 或者查找 nginx 代理 TCP 端口的配置方法

### 支持的版本

请查看 Linux 内核编译参数

```bash
$ zcat /proc/config.gz | grep NFS

CONFIG_NFS_V4=y # 说明支持 4
# CONFIG_NFS_V4_1 is not set # 说明不支持 4.1
```
