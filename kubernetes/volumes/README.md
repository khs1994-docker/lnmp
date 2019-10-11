# Docker Volumes

提供 **Volume** 各种驱动的配置方法

# NFS

* https://github.com/ehough/docker-nfs-server
* https://github.com/khs1994-docker/lnmp/blob/master/docs/volumes/nfs.md
* https://www.cnblogs.com/lykyl/archive/2013/06/14/3136921.html

之前本项目默认的 PHP 项目目录为 `./app`，你可以通过设置 `APP_ROOT` 变量来设置 PHP 项目目录。

假设你想要 PHP 项目目录 `app` 与本项目并列那么可以进行如下设置。

```bash
# APP_ROOT="../app"

APP_ROOT="../../app"
```

## WSL2

在 WSL2 上启动 NFS Server 容器不支持挂载 Windows 路径

### 第一种选择：编辑 `.env` 文件,挂载路径改为 WSL2 路径

```bash
NFS_DATA_ROOT=/opt/nfs-data
APP_ROOT=/opt/app

# 以上路径均为 WSL2 路径
```

### 第二种选择：将 本项目 克隆到 `WSL2` 路径，在 WSL2 中使用本项目
