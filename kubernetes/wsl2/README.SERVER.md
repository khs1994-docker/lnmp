# K8s Server on WSL2 ($ ./wsl2/bin/kube-server)

## 注意事项

* `wsl2.k8s.khs1994.com` 解析到 WSL2 IP
* `windows.k8s.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443` `windows.k8s.khs1994.com:16443(使用 netsh.exe 代理 wsl2 到 windows)`
* WSL2 **不要** 自定义 DNS 服务器(/etc/resolv.conf)
* 新建 `wsl-k8s` WSL 发行版用于 k8s 运行，`wsl-k8s-data`（可选）WSL 发行版用于存储数据
* 与 Docker 桌面版启动的 dockerd on WSL2 冲突，请停止并执行 `$ wsl --shutdown` 后使用本项目

## Master

* `Etcd` Windows
* `kube-wsl2windows` Windows
* `kube-apiserver` WSL2
* `kube-controller-manager` WSL2
* `kube-scheduler` WSL2

## 初始化

```powershell
$ ./lnmp-k8s
```

## 修改 windows hosts

```bash
WINDOWS_IP windows.k8s.khs1994.com
```

## 新建 `wsl-k8s` `wsl-k8s-data(可选)` WSL2 发行版

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
# $ $env:REGISTRY_MIRROR="xxxx.mirror.aliyuncs.com"
# $ $env:REGISTRY_MIRROR="mirror.baidubce.com"

$ . ../windows/sdk/dockerhub/rootfs

$ wsl --import wsl-k8s `
    C:/wsl-k8s `
    $(rootfs debian sid) `
    --version 2

# 可选
$ wsl --import wsl-k8s-data `
    C:/wsl-k8s-data `
    $(rootfs alpine) `
    --version 2

# 测试，如果命令不能正确执行，请参考 README.CLEANUP.md 注销 wsl-k8s，重启机器之后再次尝试
# 上面的步骤

$ wsl -d wsl-k8s -- uname -a

# 可选
$ wsl -d wsl-k8s-data -- uname -a
```

> 由于 WSL 存储机制，硬盘空间不能回收，我们将数据放到 `wsl-k8s-data`，若不再需要 `wsl-k8s` 直接删除 `wsl-k8s-data` 即可。例如 WSL2 放入一个 10G 文件，即使删除之后，这 10G 空间仍然占用，无法回收。
> 第二种方案，使用 wsl --mount 挂载一个物理硬盘

## WSL(wsl-k8s) 修改 APT 源并安装必要软件

```powershell
$ wsl -d wsl-k8s -- sed -i "s/deb.debian.org/mirrors.tencent.com/g" /etc/apt/sources.list

$ wsl -d wsl-k8s -- apt update

# ps 命令
$ wsl -d wsl-k8s -- apt install procps
```

## WSL(wsl-k8s) 配置挂载路径

下载并编辑 `/etc/wsl.conf`

```bash
$ wsl -d wsl-k8s

$ apt install curl vim

$ curl -o /etc/wsl.conf https://raw.githubusercontent.com/khs1994-docker/lnmp/19.03/wsl/config/wsl.conf

$ vim /etc/wsl.conf
```

```diff
- root = /mnt
+ root = /
```

```powershell
$ wsl --shutdown
```

## 挂载 `wsl-k8s` 的 `/wsl/wsl-k8s-data`

> 以下两种方法二选一

### 1. 挂载 wsl-k8s-data `/dev/sdX` 到 `/wsl/wsl-k8s-data`

```bash
$ wsl -d wsl-k8s-data df -h

Filesystem                Size      Used Available Use% Mounted on
/dev/sdc                251.0G     12.4G    225.8G   5% /

# 在 wsl-k8s 中将 /dev/sdc(不固定，必须通过上面的命令获取该值) 挂载到 /wsl/wsl-k8s-data

$ wsl -d wsl-k8s -u root -- mkdir -p /wsl/wsl-k8s-data
$ wsl -d wsl-k8s -u root -- mount /dev/sdX /wsl/wsl-k8s-data
```

### 2. 挂载物理硬盘到 `wsl-k8s` 的 `/wsl/wsl-k8s-data` ( Windows 20226+)

```powershell
# 以管理员权限打开 powershell
$ wmic diskdrive list brief
Caption                 DeviceID            Model                   Partitions  Size
KINGSTON SA400S37240G   \\.\PHYSICALDRIVE1  KINGSTON SA400S37240G   3           240054796800
WDC WDS250G1B0A-00H9H0  \\.\PHYSICALDRIVE0  WDC WDS250G1B0A-00H9H0  2           250056737280

$ wsl --mount \\.\PHYSICALDRIVE0 --bare
```

```bash
$ wsl -d wsl-k8s

$ lsblk

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop1    7:1    0   292M  1 loop
sdd      8:48   0   256G  0 disk /
sde      8:64   0 232.9G  0 disk
|-sde1   8:65   0   200M  0 part
|-sde2   8:66   0 139.5G  0 part
`-sde3   8:67   0  93.2G  0 part

$ mkdir -p /wsl/wsl-k8s-data/
$ mount /dev/sde3 /wsl/wsl-k8s-data/
```

## 获取 kubernetes

```bash
$ cd ~/lnmp/kubernetes

$ wsl -d wsl-k8s

$ ./lnmp-k8s kubernetes-server --url
# 如果上面的命令出现错误，可以执行这个命令
# $ ./lnmp-k8s kubernetes-server

# 其他架构
# $ ./lnmp-k8s kubernetes-server --url linux arm64
# $ ./lnmp-k8s kubernetes-server linux arm64
```

## 生成证书文件

**启动桌面版 Docker**

```bash
$ cd ~/lnmp/kubernetes

$ docker-compose up cfssl-wsl2
```

**退出 桌面版 Docker** 并执行以下命令

```bash
$ wsl --shutdown
```

## `WSL2` 文件准备

```bash
$ ./wsl2/bin/kube-check

$ wsl -d wsl-k8s

$ set -x
$ source wsl2/.env

$ mkdir -p ${K8S_ROOT:?err}
$ mkdir -p ${K8S_ROOT:?err}/{etc/kubernetes/pki,bin}
$ cp -a wsl2/certs/. ${K8S_ROOT:?err}/etc/kubernetes/pki/
$ mv ${K8S_ROOT:?err}/etc/kubernetes/pki/*.yaml ${K8S_ROOT:?err}/etc/kubernetes
$ mv ${K8S_ROOT:?err}/etc/kubernetes/pki/*.kubeconfig ${K8S_ROOT:?err}/etc/kubernetes

$ cp -a kubernetes-release/release/v1.19.0-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} ${K8S_ROOT:?err}/bin
```

## Windows 启动 Etcd

`lwpm` 安装 Etcd

```powershell
$ ./wsl2/etcd

$ get-process etcd
```

## Windows 启动 wsl2windows 代理

```powershell
$ ./wsl2/kube-wsl2windows k8s
```

## 设置 ~/.kube/config

**windows**

```powershell
$ mkdir $home/.kube

$ ./wsl2/bin/kubectl-config-set-cluster
```

**WSL**

将 K8S 配置写入 WSL `~/.kube/config`

```bash
$ ./wsl2/bin/kubectl-config-sync
```
