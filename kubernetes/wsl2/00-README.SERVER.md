# K8s Server on WSL2

## 注意事项

* `wsl2.k8s.khs1994.com` 解析到 WSL2 IP
* `windows.k8s.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443` `windows.k8s.khs1994.com:16443(使用 netsh.exe 代理 wsl2 到 windows)`
* WSL2 **不要** 自定义 DNS 服务器(/etc/resolv.conf)
* 新建 `wsl-k8s` WSL 发行版用于 k8s 运行，`wsl-k8s-data`（可选）WSL 发行版用于存储数据
* 与 Docker 桌面版启动的 dockerd on WSL2 冲突，请停止并执行 `$ wsl --shutdown` 后使用本项目

## Master

* `Etcd` WSL2
* `kube-wsl2windows` Windows
* `kube-apiserver` WSL2
* `kube-controller-manager` WSL2
* `kube-scheduler` WSL2

## 初始化

```powershell
$ ./lnmp-k8s
```

## 新建 `wsl-k8s` `wsl-k8s-data(可选)` WSL2 发行版

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
$ . ../windows/sdk/dockerhub/rootfs

$ wsl --import wsl-k8s `
    $env:LOCALAPPDATA\wsl-k8s `
    $(rootfs library-mirror/ubuntu 20.04 -registry ccr.ccs.tencentyun.com) `
    --version 2

# 可选
$ wsl --import wsl-k8s-data `
    $env:LOCALAPPDATA\wsl-k8s-data `
    $(rootfs library-mirror/alpine -registry ccr.ccs.tencentyun.com) `
    --version 2

# 测试，如果命令不能正确执行，请参考 README.CLEANUP.md 注销 wsl-k8s，重启机器之后再次尝试上面的步骤
# 如果仍然遇到错误，请将上述命令改为 --version 1，再将 WSL1 转换为 WSL2 （$ wsl --set-version wsl-k8s 2）
# 或者先让一个 WSL2 发行版处于运行状态（$ wsl -d ubuntu），再执行上述命令

$ wsl -d wsl-k8s -- uname -a

# 可选
$ wsl -d wsl-k8s-data -- uname -a
```

> 由于 WSL 存储机制，硬盘空间不能回收，我们将数据放到 `wsl-k8s-data`，若不再需要 `wsl-k8s` 直接删除 `wsl-k8s-data` 即可。例如 WSL2 放入一个 10G 文件，即使删除之后，这 10G 空间仍然占用，无法回收。
> 第二种方案，使用 wsl --mount 挂载一个物理硬盘

## WSL(wsl-k8s) 修改 APT 源并安装必要软件

```powershell
# $ wsl -d wsl-k8s -- sed -i "s/deb.debian.org/mirrors.tencent.com/g" /etc/apt/sources.list
$ wsl -d wsl-k8s -- sed -i "s/archive.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list
$ wsl -d wsl-k8s -- sed -i "s/security.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list

$ wsl -d wsl-k8s -- apt update

# ps 命令
$ wsl -d wsl-k8s -- apt install procps bash-completion
$ wsl -d wsl-k8s -- apt install iproute2 jq
```

## WSL(wsl-k8s) 配置挂载路径

下载并编辑 `/etc/wsl.conf`

```bash
$ wsl -d wsl-k8s

$ apt install curl vim

$ cp ../wsl/config/wsl.conf /etc/wsl.conf

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

# 以下命令参数值请替换为实际的值
$ wsl --mount \\.\PHYSICALDRIVE0 --partition 3

# 格式化空白硬盘
# $ wsl --mount \\.\PHYSICALDRIVE0 --bare
# $ fdisk /dev/sdX
# 自行学习使用 fdisk 命令
# $ mkfs.ext4 /dev/sdXN
```

**设置 .env.ps1 文件**

```powershell
$MountPhysicalDiskDeviceID2WSL2="\\.\PHYSICALDRIVE0"
$MountPhysicalDiskPartitions2WSL2="3"
$MountPhysicalDiskType2WSL2="ext4"
```

```bash
$ wsl -d wsl-k8s

$ mount -t ext4

/dev/sdb on / type ext4 (rw,relatime,discard,errors=remount-ro,data=ordered)
/dev/sda3 on /wsl/PHYSICALDRIVE0p3 type ext4 (rw,relatime)

# /dev/sda3 为物理硬盘，将其挂载到 /wsl/wsl-k8s-data/
$ mkdir -p /wsl/wsl-k8s-data/
$ mount /dev/sda3 /wsl/wsl-k8s-data/
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

```powershell
$ ./wsl2/bin/kube-check

$ wsl -d wsl-k8s
```

```bash
$ set -x
$ source wsl2/.env

$ mkdir -p ${K8S_ROOT:?err}
$ mkdir -p ${K8S_ROOT:?err}/{etc/kubernetes/pki,bin}
$ cp -a wsl2/certs/. ${K8S_ROOT:?err}/etc/kubernetes/pki/
$ mv ${K8S_ROOT:?err}/etc/kubernetes/pki/*.yaml ${K8S_ROOT:?err}/etc/kubernetes
$ mv ${K8S_ROOT:?err}/etc/kubernetes/pki/*.kubeconfig ${K8S_ROOT:?err}/etc/kubernetes

# 请将 1.21.0 替换为实际的 k8s 版本号
$ cp -a kubernetes-release/release/v1.21.0-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} ${K8S_ROOT:?err}/bin
```

## kubectl

请查看 [00-README.kubectl.md](00-README.kubectl.md)

## 启动 K8S

请查看 [00-README.systemd.md](00-README.systemd.md)
