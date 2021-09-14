# NFSv4

> 基于 NFS v4 版本

* https://github.com/ehough/docker-nfs-server
* https://www.cnblogs.com/lykyl/archive/2013/06/14/3136921.html

* https://github.com/khs1994-docker/lnmp/blob/master/docs/volumes/nfs.md

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

### 挂载路径改为 WSL2 路径

编辑 `.env` 文件

```bash
NFS_DATA_ROOT=/opt/nfs-data
APP_ROOT=/opt/app

# 以上路径均为 WSL2 路径
```

### 支持的版本

请查看 Linux 内核编译参数

```bash
$ zcat /proc/config.gz | grep NFS

CONFIG_NFS_V4=y # 说明支持 4
# CONFIG_NFS_V4_1 is not set # 说明不支持 4.1
```
