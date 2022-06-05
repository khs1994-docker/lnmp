# K8s Server on WSL2

## 注意事项

* `wsl2.k8s.khs1994.com` 解析到 WSL2 IP
* `windows.k8s.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443` `windows.k8s.khs1994.com:16443(使用 netsh.exe 代理 wsl2 到 windows)`
* WSL2 **不要** 自定义 DNS 服务器(不要自行编辑 /etc/resolv.conf)
* 新建 `wsl-k8s` WSL 发行版用于 k8s 运行
* （可选）新建 `wsl-k8s-data` WSL 发行版用于存储数据
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

## 新建 `wsl-k8s` `wsl-k8s-data(如果不挂载物理硬盘)` WSL2 发行版

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
$ . ../windows/sdk/dockerhub/rootfs

$ wsl --import wsl-k8s `
    $env:LOCALAPPDATA\wsl-k8s `
    $(rootfs library-mirror/debian sid -registry ccr.ccs.tencentyun.com) `
    --version 2

# 如果不挂载物理硬盘请执行如下命令
$ wsl --import wsl-k8s-data `
    $env:LOCALAPPDATA\wsl-k8s-data `
    $(rootfs library-mirror/alpine -registry ccr.ccs.tencentyun.com) `
    --version 2

# 测试
# 如果命令不能正确执行，请参考 README.CLEANUP.md 注销 wsl-k8s，重启机器之后再次尝试上面的步骤
# 如果仍然遇到错误，请将上述命令改为 --version 1，再将 WSL1 转换为 WSL2 （$ wsl --set-version wsl-k8s 2）
# 或者先让一个 WSL2 发行版处于运行状态（$ wsl -d ubuntu），再执行上述命令

$ wsl -d wsl-k8s -- uname -a

# # 如果不挂载物理硬盘请执行如下命令
$ wsl -d wsl-k8s-data -- uname -a
```

> 由于 WSL 存储机制，硬盘空间不能回收，我们将数据放到 `wsl-k8s-data`，若不再需要 `wsl-k8s` 直接删除 `wsl-k8s-data` 即可。例如 WSL2 放入一个 10G 文件，即使删除之后，这 10G 空间仍然占用，无法回收。
> 第二种方案，使用 wsl --mount 挂载一个物理硬盘

## WSL(wsl-k8s) 修改 APT 源并安装必要软件

```powershell
$ wsl -d wsl-k8s -- sed -i "s/deb.debian.org/mirrors.tencent.com/g" /etc/apt/sources.list
# $ wsl -d wsl-k8s -- sed -i "s/archive.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list
# $ wsl -d wsl-k8s -- sed -i "s/security.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list

$ wsl -d wsl-k8s -- apt update

# ps 命令
$ wsl -d wsl-k8s -- apt install -y procps bash-completion
$ wsl -d wsl-k8s -- apt install -y iproute2 jq curl vim fdisk
```

## WSL(wsl-k8s) 复制配置文件

```powershell
$ wsl -d wsl-k8s -- sh -xc 'cp wsl2/conf/etc/wsl.conf /etc/wsl.conf && cat /etc/wsl.conf'
# 停止 WSL 使配置生效
$ wsl --shutdown
```

## 挂载 `wsl-k8s` 的 `/wsl/wsl-k8s-data`

> 以下两种方法二选一

### 1. (如果不挂载物理硬盘)挂载 wsl-k8s-data `/dev/sdX` 到 `/wsl/wsl-k8s-data`

```powershell
$ ./wsl2/bin/wsl2d.ps1 wsl-k8s
$ wsl -d wsl-k8s-data -- df -h

Filesystem                Size      Used Available Use% Mounted on
/dev/sdc                251.0G     12.4G    225.8G   5% /

# 在 wsl-k8s 中将 /dev/sdc(不固定，必须通过上面的命令获取该值) 挂载到 /wsl/wsl-k8s-data

$ wsl -d wsl-k8s -u root -- sh -xc 'mkdir -p /wsl/wsl-k8s-data && mount /dev/sdX /wsl/wsl-k8s-data'
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

# 会将 /dev/sdXN 挂载到 挂载点(/etc/wsl.conf [automount] root=挂载点)/wsl/PHYSICALDRIVE0pN
```

#### 格式化空白硬盘

在 Windows 磁盘管理中删除卷

```bash
$ wsl --mount \\.\PHYSICALDRIVE0 --bare
$ fdisk -l
$ fdisk /dev/sdX
# 自行学习使用 fdisk 命令
$ fdisk /dev/sdX

Welcome to fdisk (util-linux 2.38).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): 输入n
Partition number (5-128, default 5): 按回车
First sector (466944-468862094, default 466944): 按回车
Last sector, +/-sectors or +/-size{K,M,G,T,P} (466944-466489343, default 466489343): 按回车

Created a new partition 5 of type 'Linux filesystem' and of size 222.2 GiB.
Partition #5 contains a ext4 signature.

Do you want to remove the signature? [Y]es/[N]o: 输入yes

The signature will be removed by a write command.

Command (m for help): 输入w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.


$ mkfs.ext4 /dev/sdXN
```

**设置 .env.ps1 文件**

```powershell
$MountPhysicalDiskDeviceID2WSL2="\\.\PHYSICALDRIVE0"
$MountPhysicalDiskPartitions2WSL2="3"
$MountPhysicalDiskType2WSL2="ext4"
```

```powershell
$ ./wsl2/bin/wsl2d.ps1 wsl-k8s
$ wsl -d wsl-k8s -- mount -t ext4

/dev/sdb on / type ext4 (rw,relatime,discard,errors=remount-ro,data=ordered)
/dev/sda3 on /wsl/PHYSICALDRIVE0p3 type ext4 (rw,relatime)

# /dev/sda3 为物理硬盘，将其挂载到 /wsl/wsl-k8s-data/
$ wsl -d wsl-k8s -- sh -xc 'mkdir -p /wsl/wsl-k8s-data/ && mount /dev/sda3 /wsl/wsl-k8s-data/'
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
# 该命令执行结果最后一行会给出文件地址
$ rootfs khs1994/k8s-cfssl -ref all-in-one
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
$ ./wsl2/bin/kube-check

$env:WSLENV="K8S_ROOT/u"
$env:K8S_ROOT="/wsl/wsl-k8s-data/k8s"
$ wsl -d wsl-k8s -- bash -xc 'mkdir -p ${K8S_ROOT:?err}/{etc/kubernetes/pki,bin}'
$ wsl -d wsl-k8s -- sh -xc 'cp ${K8S_ROOT:?err}/etc/kubernetes/pki/*.yaml       ${K8S_ROOT:?err}/etc/kubernetes'
$ wsl -d wsl-k8s -- sh -xc 'cp ${K8S_ROOT:?err}/etc/kubernetes/pki/*.kubeconfig ${K8S_ROOT:?err}/etc/kubernetes'

# 请将 1.24.0 替换为实际的 k8s 版本号
$ wsl -d wsl-k8s -- bash -xc 'cp -a kubernetes-release/release/v1.24.0-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} ${K8S_ROOT:?err}/bin'
```

## 工作节点配置

请查看 [00-README.md](00-README.md)
