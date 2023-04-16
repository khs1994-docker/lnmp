# K8s Server on WSL2

## 注意事项

* `wsl2.k8s.khs1994.com` 解析到 WSL2 IP
* `windows.k8s.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443` `windows.k8s.khs1994.com:16443(使用 netsh.exe 代理 wsl2 到 windows)`
* WSL2 **不要** 自定义 DNS 服务器(不要自行编辑 /etc/resolv.conf)
* 新建 `wsl-k8s` WSL2 发行版用于 k8s 运行
* （可选）新建 `wsl-k8s-data` WSL2 发行版用于存储数据
* 本项目与 **Docker 桌面版** 冲突，请先停止 **Docker 桌面版** 并执行 `$ wsl --shutdown` 后使用本项目

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

## 确定 Windows IP

替换 `.env` 文件中 `NODE_IPS` 值

```bash
# Windows IP
NODE_IPS=192.168.1.192
```

## 新建 `wsl-k8s` WSL2 发行版并进行配置

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
$ . ../windows/sdk/dockerhub/rootfs

$ wsl --import wsl-k8s `
    $env:LOCALAPPDATA\wsl-k8s `
    $(rootfs library-mirror/debian sid -registry ccr.ccs.tencentyun.com) `
    --version 2

$ wsl -d wsl-k8s -- uname -a
```

### 修改 APT 源并安装必要软件

```powershell
$ wsl -d wsl-k8s -- sed -i "s/deb.debian.org/mirrors.tencent.com/g" /etc/apt/sources.list
# $ wsl -d wsl-k8s -- sed -i "s/archive.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list
# $ wsl -d wsl-k8s -- sed -i "s/security.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list

$ wsl -d wsl-k8s -- apt update

# procps => ps 命令
$ wsl -d wsl-k8s -- apt install -y procps bash-completion iproute2 jq curl vim fdisk net-tools
```

### 复制配置文件

```powershell
$ wsl -d wsl-k8s -- sh -xc 'cp wsl2/conf/etc/wsl.conf /etc/wsl.conf && cat /etc/wsl.conf'
# 停止 WSL 使配置生效
$ wsl --shutdown
```

## 新建 `wsl-k8s-data` WSL2 发行版或者挂载物理硬盘

> 由于 WSL 存储机制，硬盘空间不能回收，我们将数据放到 `wsl-k8s-data`，若不再需要 `wsl-k8s` 直接删除 `wsl-k8s-data` 即可。例如 WSL2 放入一个 10G 文件，即使删除之后，这 10G 空间仍然占用，无法回收。

> 也可以使用 wsl --mount 挂载一个物理硬盘(**电脑第二硬盘位**/**USB接移动硬盘**)用来存放数据

## 一、新建 `wsl-k8s-data` WSL2 发行版(不挂载物理硬盘)

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
$ . ../windows/sdk/dockerhub/rootfs

$ wsl --import wsl-k8s-data `
    $env:LOCALAPPDATA\wsl-k8s-data `
    $(rootfs library-mirror/alpine -registry ccr.ccs.tencentyun.com) `
    --version 2

$ wsl -d wsl-k8s-data -- uname -a
```

### 挂载 `wsl-k8s-data` WSL2 发行版的 `/dev/sdX` 到 `wsl-k8s` WSL2 发行版的 `/wsl/wsl-k8s-data`

```powershell
$ ./wsl2/bin/wsl2d.ps1 wsl-k8s
$ wsl -d wsl-k8s-data -- df -h

Filesystem                Size      Used Available Use% Mounted on
/dev/sdc               1006.9G      6.0M    955.6G   0% /

# 在 wsl-k8s 中将 /dev/sdc(不固定，必须通过上面的命令获取该值) 挂载到 /wsl/wsl-k8s-data

$ wsl -d wsl-k8s -u root -- sh -xc 'mkdir -p /wsl/wsl-k8s-data && mount /dev/sdX /wsl/wsl-k8s-data'
```

## 二、挂载物理硬盘(电脑第二硬盘位/USB接移动硬盘)

### 挂载物理硬盘到 `wsl-k8s` 的 `/wsl/wsl-k8s-data` (Windows 20226+)

查看硬盘列表

```powershell
# 以管理员权限打开 powershell
$ wmic diskdrive list brief
Caption                 DeviceID            Model                   Partitions  Size
KINGSTON SA400S37240G   \\.\PHYSICALDRIVE1  KINGSTON SA400S37240G   2           240054796800
WDC WDS250G1B0A-00H9H0  \\.\PHYSICALDRIVE0  WDC WDS250G1B0A-00H9H0  2           250056737280
```

如果你的硬盘没有 `ext4` 分区，请查看 [00-README.MKFS.md](00-README.MKFS.md)。

如果你的硬盘拥有了 `ext4` 分区，则可以先 **执行命令挂载**

```powershell
$ ./wsl2/bin/wsl2d.ps1 wsl-k8s

# 请将 PHYSICALDRIVE<N> --partition <P> 替换为实际的值
$ wsl --mount \\.\PHYSICALDRIVE1 --partition 2

# 会将 /dev/sd<X><P> 挂载到 挂载点(/etc/wsl.conf [automount] root=挂载点)/wsl/PHYSICALDRIVE<N>p<P>

$ wsl -d wsl-k8s -- mount -t ext4

/dev/sdb on / type ext4 (rw,relatime,discard,errors=remount-ro,data=ordered)
/dev/sdb2 on /wsl/PHYSICALDRIVE1p2 type ext4 (rw,relatime)

# /dev/sdb2 为物理硬盘，将其挂载到 /wsl/wsl-k8s-data/
$ wsl -d wsl-k8s -- sh -xc 'mkdir -p /wsl/wsl-k8s-data/ && mount /dev/sdb2 /wsl/wsl-k8s-data/'
```

**手动执行命令挂载之后，在 .env.ps1 文件中配置，尝试通过 `./wsl2/bin/kube-check` 挂载**

```powershell
$MountPhysicalDiskDeviceID2WSL2="\\.\PHYSICALDRIVE1"
$MountPhysicalDiskPartitions2WSL2="2"
$MountPhysicalDiskType2WSL2="ext4"
```

**停止 WSL2**

```powershell
$ wsl --shutdown
```

**尝试通过 `./wsl2/bin/kube-check` 挂载**

```powershell
$ ./wsl2/bin/kube-check
```

## 获取 kubernetes

```powershell
$ wsl -d wsl-k8s -- ./lnmp-k8s kubernetes-server --url
# 如果上面的命令出现错误，可以执行这个命令
# $ wsl -d wsl-k8s -- ./lnmp-k8s kubernetes-server

# 其他架构
# $ wsl -d wsl-k8s -- ./lnmp-k8s kubernetes-server --url linux arm64
# $ wsl -d wsl-k8s -- ./lnmp-k8s kubernetes-server linux arm64
```

## 生成证书文件

```powershell
$env:WSLENV="CFSSL_ROOT/u:CFSSL_ROOTFS/u"
$env:CFSSL_ROOT="/wsl/wsl-k8s-data/cfssl"
$env:CFSSL_ROOTFS="/wsl/wsl-k8s-data/cfssl/rootfs"

$ wsl -d wsl-k8s -- sh -xc 'mkdir ${CFSSL_ROOT:?err}'
$ . ../windows/sdk/dockerhub/rootfs
# 该命令执行结果最后一行会给出<文件地址>
$ rootfs khs1994-docker/khs1994/k8s-cfssl -ref all-in-one -registry pcit-docker.pkg.coding.net
$ cp <文件地址> \\wsl$\wsl-k8s\"${env:CFSSL_ROOTFS}".tar.gz

$ wsl -d wsl-k8s -- sh -xc 'mkdir ${CFSSL_ROOTFS:?err}'
$ wsl -d wsl-k8s -- sh -xc 'tar -C ${CFSSL_ROOTFS:?err} -zxvf ${CFSSL_ROOTFS:?err}.tar.gz'

$ wsl -d wsl-k8s -- sh -xc 'cp wsl2/cfssl/config.json ${CFSSL_ROOT:?err}/'
$ wsl -d wsl-k8s -- bash -xc 'cp wsl2/{.env,.env.example} cfssl/{docker-entrypoint.sh,kube-scheduler.config.yaml} ${CFSSL_ROOTFS:?err}/'

$ wsl -d wsl-k8s -- ./lnmp-k8s _runc_install
$ wsl -d wsl-k8s -- sh -xc 'cd ${CFSSL_ROOT:?err} && runc run cfssl'
```

## `WSL2` 文件准备

```powershell
$env:WSLENV="K8S_ROOT/u"
$env:K8S_ROOT="/wsl/wsl-k8s-data/k8s"
$ wsl -d wsl-k8s -- bash -xc 'mkdir -p ${K8S_ROOT:?err}/{etc/kubernetes/pki,bin}'
$ wsl -d wsl-k8s -- sh -xc 'cp ${K8S_ROOT:?err}/etc/kubernetes/pki/*.yaml       ${K8S_ROOT:?err}/etc/kubernetes'
$ wsl -d wsl-k8s -- sh -xc 'cp ${K8S_ROOT:?err}/etc/kubernetes/pki/*.kubeconfig ${K8S_ROOT:?err}/etc/kubernetes'

# 请将 1.27.0 替换为实际的 k8s 版本号
$ wsl -d wsl-k8s -- bash -xc 'cp -a kubernetes-release/release/v1.27.0-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} ${K8S_ROOT:?err}/bin'
```

## 工作节点配置

请查看 [00-README.NODE.md](00-README.NODE.md)
