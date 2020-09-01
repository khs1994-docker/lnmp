# NFS Volume(NFSv4)

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

**NFS 数据卷** 是跨主机的容器数据存储方案之一。

## NFS 各个版本的区别

* https://blog.csdn.net/ycnian/article/details/8515517

本文以 `NFSv4` 版本为例，无需 RPC `111` 端口, 只需监听 `2049` 端口即可。

## 配置 NFS Server 容器

在 `kubernetes/nfs-server/.env` 文件中配置

`NFS_EXPORT_N` 变量值为容器中 `/etc/exports` 中的每一行

部分设置项解释

```bash
/home/work 192.168.0.*(rw,fsid=0,insecure,sync,no_root_squash)
# /home/work 192.168.1.0/24(rw,fsid=0,insecure,sync,no_root_squash)
# /home/work *(rw,fsid=0,insecure,sync,no_root_squash)

# 同一目录的访问规则请写在同一行
```

`rw` read-write 可读写;注意，仅仅这里设置成读写客户端还是不能正常写入，还要正确地设置共享目录的权限，参考问题7

`ro` read-only 只读；

`sync` 文件同时写入硬盘和内存；

`async` 文件暂存于内存，而不是直接写入内存；

`no_root_squash` NFS 客户端连接服务端时如果使用的是 root 的话，那么对服务端分享的目录来说，也拥有 root 权限。显然开启这项是不安全的。

`root_squash` NFS 客户端连接服务端时如果使用的是 root 的话，那么对服务端分享的目录来说，拥有匿名用户权限，通常他将使用 nobody 或 nfsnobody 身份；

`all_squash` 不论 NFS 客户端连接服务端时使用什么用户，对服务端分享的目录来说都是拥有匿名用户权限；

`anonuid` 匿名用户的 UID 值，通常是 nobody 或 nfsnobody，可以在此处自行设定；

`anongid` 匿名用户的 GID 值。

`subtree_check`（默认） 若输出目录是一个子目录，则nfs服务器将检查其父目录的权限；
`no_subtree_check` 即使输出目录是一个子目录，nfs服务器也不检查其父目录的权限，这样可以提高效率；

`insecure`

### `fsid=0`

`NFSv4` 文件系统的命令空间发生了变化，服务器端必须设置一个根文件系统(`fsid=0`)，其他文件系统挂载在根文件系统上导出。

```bash
/home  192.168.78.0/24(rw,fsid=0,insecure,sync,no_root_squash)  #导出虚拟根目录

/home/nfs  192.168.78.0/24(rw,insecure,sync,no_root_squash)    #导出虚拟根下的子目录1

/home/data  192.168.78.0/24(rw,insecure,sync,no_root_squash)   #导出虚拟根下的子目录2
```

## 客户端挂载

安装依赖

```bash
$ sudo apt install -y nfs-common

$ sudo yum install -y nfs-utils
```

挂载

```bash
$ sudo mount -t nfs4 -v -o vers=4.2 192.168.78.1:/nfs   /tmp/nfs

$ sudo mount -t nfs4 -v -o vers=4.2 192.168.78.1:/data  /tmp/data
```

`-o` 所支持的参数请通过 `$ man nfs` 查看

## 客户端支持的 NFS 版本 (-o vers=4.2) 与 Linux 内核有关

* https://github.com/torvalds/linux/blob/master/fs/nfs/Kconfig

```bash
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_V4_2 is not set
```

使用以上参数编译的 Linux 内核不支持 NFS `4.1` `4.2`,添加以下编译参数即可:

```bash
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
```

```bash
$ cat /lib/modules/$(uname -r)/modules.builtin | grep nfs

$ zcat /proc/config.gz | grep NFS
```

## 加载内核模块

```bash
$ sudo modprobe {nfs,nfsd,rpcsec_gss_krb5}
```

## 容器运行 NFS 服务端

* https://github.com/ehough/docker-nfs-server

```bash
$ cd kubernetes/nfs-server

$ docker-compose up [-d] nfs

# 或者可以直接执行
$ lnmp-docker nfs [down]
```

或者执行 `$ docker run XXX`

```bash
# exports.txt
/nfs *(rw,fsid=0,insecure,no_root_squash,no_subtree_check)
/nfs/data *(rw,insecure,no_root_squash,no_subtree_check)
```

```bash
$ docker run -it \
    -v /nfs:/nfs:rw \
    -p 2049:2049 \
    -v ${PWD}/exports.txt:/etc/exports:ro \
    -e NFS_DISABLE_VERSION_3=1 \
    --cap-add SYS_ADMIN \
    --privileged \
    erichough/nfs-server
```

## 宿主机安装 NFS 服务端

* https://help.ubuntu.com/community/SettingUpNFSHowTo

```bash
$ sudo apt install -y --no-install-recommends nfs-kernel-server kmod libcap2-bin

$ sudo yum install nfs-utils rpcbind
```

```bash
$ sudo systemctl start nfs
```

编辑 `/etc/exports` 文件

## NFS 客户端尝试挂载

* 客户端必须确保 RPC 协议相应的 portmap 正常运行，否则 mount 将失败 (NFSv3 Only)

```bash
# $ systemctl start rpcbind.service

# $ showmount -e ${SERVER_IP:-192.168.199.100} # nfs4 not support

$ sudo mkdir /cli-nfs

# 虽然服务端指定的是 /nfs 这里对应为 /
# 必须通过 -t 指定类型，默认为 nfs3 (根据操作系统的不同默认挂载类型也不同)
$ sudo mount -v -t nfs4 -o vers=4.2,proto=tcp,port=2049 ${SERVER_IP:-192.168.199.100}:/ /cli-nfs

$ mount
```

## 容器挂载 NFS Volume

* https://docs.docker.com/storage/volumes/#choose-the--v-or---mount-flag
* https://docs.docker.com/storage/volumes/#create-a-service-which-creates-an-nfs-volume

```bash
# 创建 NFS 数据卷
# Docker 桌面版 支持 vers=4.2
$ docker volume create volume-nfs \
    -d local \
    -o type=nfs \
    -o device=192.168.199.100:/ \
    -o o=addr=192.168.199.100,vers=4,soft,timeo=180,bg,tcp,rw

# 挂载
$ docker container run -it --rm \
    --mount "type=volume,src=volume-nfs,dst=/data" \
    busybox sh

# 或者在 --mount 中直接配置
$ docker container run -it --rm \
      --mount 'type=volume,src=volume-nfs,dst=/data,volume-driver=local,volume-opt=type=nfs,volume-opt=device=192.168.199.100:/,"volume-opt=o=addr=192.168.199.100,vers=4,soft,timeo=180,bg,tcp,rw"' busybox sh
```

支持哪些 NFS 版本 `4.2` `4.1` `4` 与宿主机一致,可以在宿主机使用 `$ sudo mount -t nfs4 -v XXX` 进行测试

宿主机不支持 `4.2`, `$ docker run` 指定 `vers=4.2` 也会出错

## Compose 中使用 NFS volume

请查看 `scripts/docker-example.yml` 文件的 `volumes` 部分

## Windows 10 挂载 NFS

* https://docs.microsoft.com/en-us/windows-server/storage/nfs/nfs-overview#windows-and-windows-server-versions

**只支持 NFSv2, NFSv3**

## More Information

* https://blog.csdn.net/xuplus/article/details/51669063

* https://blog.csdn.net/bbwangj/article/details/78599038

* https://blog.csdn.net/younger_china/article/details/52175085

* https://github.com/kubernetes/examples/blob/master/staging/volumes/nfs/nfs-server-rc.yaml

* https://www.cnblogs.com/lykyl/archive/2013/06/14/3136921.html
