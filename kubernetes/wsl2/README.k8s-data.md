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
