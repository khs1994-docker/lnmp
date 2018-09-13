# NFS Volume

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

**NFS 数据卷** 是跨主机的容器数据存储方案之一。

## NFS 各个版本的区别

* https://blog.csdn.net/ycnian/article/details/8515517

本文以 `NFSv4` 版本为例，无需 RPC `111` 端口, 只需监听 `2049` 端口即可。

## 配置 IP 段

在 `volumes/.env` 文件中配置

`NFS_EXPORT_N` 变量值为容器中 `/etc/exports` 中的每一行

部分设置项解释

```bash
/home/work 192.168.0.*(rw,fsid=0,insecure,sync,no_root_squash)
# /home/work 192.168.1.0/24(rw,fsid=0,insecure,sync,no_root_squash)
# /home/work *(rw,fsid=0,insecure,sync,no_root_squash)

# 同一目录的访问规则请写在同一行，上边只是列出规则的写法

rw：read-write，可读写;注意，仅仅这里设置成读写客户端还是不能正常写入，还要正确地设置共享目录的权限，参考问题7
ro：read-only，只读；

sync：文件同时写入硬盘和内存；
async：文件暂存于内存，而不是直接写入内存；

no_root_squash：NFS 客户端连接服务端时如果使用的是 root 的话，那么对服务端分享的目录来说，也拥有 root 权限。显然开启这项是不安全的。
root_squash：NFS 客户端连接服务端时如果使用的是 root 的话，那么对服务端分享的目录来说，拥有匿名用户权限，通常他将使用 nobody 或 nfsnobody 身份；
all_squash：不论 NFS 客户端连接服务端时使用什么用户，对服务端分享的目录来说都是拥有匿名用户权限；

anonuid：匿名用户的 UID 值，通常是 nobody 或 nfsnobody，可以在此处自行设定；
anongid：匿名用户的 GID 值。

no_subtree_check:
insecure:
```

### `fsid=0`

`NFSv4` 文件系统的命令空间发生了变化，服务器端必须设置一个根文件系统(fsid=0)，其他文件系统挂载在根文件系统上导出。

```bash
/home  192.168.78.0/24(rw,fsid=0,insecure,sync,no_root_squash)  #导出虚拟根目录

/home/nfs  192.168.78.0/24(rw,insecure,sync,no_root_squash)    #导出虚拟根下的子目录1

/home/data  192.168.78.0/24(rw,insecure,sync,no_root_squash)   #导出虚拟根下的子目录2

# 客户端对应的挂载命令如下

sudo mount -t nfs4 192.168.78.1:/nfs   /tmp/nfs

sudo mount -t nfs4 192.168.78.1:/data  /tmp/data
```

## 加载内核模块

```bash
$ sudo modprobe {nfs,nfsd,rpcsec_gss_krb5}
```

## 容器运行 NFS 服务端

```bash
$ cd volumes

$ docker-compose up [-d] nfs # or $ lnmp-docker nfs [down]
```

* https://github.com/ehough/docker-nfs-server

```bash
$ docker run -it \
    -v /nfs:/nfs:rw \
    -p 2049:2049 \
    -e NFS_EXPORT_0='/nfs *(rw,fsid=0,insecure,no_root_squash,no_subtree_check)'  \
    -e NFS_EXPORT_1='/nfs/data *(rw,insecure,no_root_squash,no_subtree_check)'  \
    -e NFS_DISABLE_VERSION_3=1 \
    --cap-add SYS_ADMIN \
    --privileged \
    erichough/nfs-server
```

* NFSv3 port `111` `20048`
* `--privileged`

## 系统安装 NFS 服务端

* https://help.ubuntu.com/community/SettingUpNFSHowTo

```bash
$ sudo apt install -y --no-install-recommends nfs-kernel-server kmod libcap2-bin
```

```bash
$ sudo yum install nfs-utils rpcbind

$ sudo systemctl start nfs
```

自行编辑 `/etc/exports` 文件

## NFS 客户端尝试挂载

* 客户端必须确保 RPC 协议相应的 portmap 正常运行，否则 mount 将失败 (NFSv3 Only)

```bash
# $ systemctl start rpcbind.service

# $ showmount -e ${SERVER_IP:-192.168.199.100} # nfs4 not support

$ sudo mkdir /nfs

# 虽然服务端指定的是 /nfs 这里对应为 /
# 必须通过 -t 指定类型，默认为 nfs3
$ sudo mount -v -t nfs4 -o proto=tcp,port=2049 ${SERVER_IP:-192.168.199.100}:/ /nfs

$ mount
```

## 容器挂载 NFS Volume

* https://docs.docker.com/storage/volumes/#choose-the--v-or---mount-flag

```bash
$ docker volume create volume-nfs \
    -d local \
    -o type=nfs \
    -o device=192.168.199.100:/ \
    -o o=addr=192.168.199.100,vers=4,soft,timeo=180,bg,tcp,rw

$ docker container run -it --rm \
    --mount "type=volume,src=volume-nfs,dst=/data" \
    busybox sh

# $ docker container run -it --rm \
# --mount 'type=volume,src=volume-nfs,dst=/data,volume-driver=local,volume-opt=type=nfs,volume-opt=device=192.168.199.100:/,"volume-opt=o=addr=192.168.199.100,vers=4,soft,timeo=180,bg,tcp,rw"' busybox sh
```

## Compose 中使用 NFS volume

请查看 `docker-example.yml` 文件的 `volumes` 部分

## More Information

* https://blog.csdn.net/xuplus/article/details/51669063

* https://blog.csdn.net/bbwangj/article/details/78599038

* https://blog.csdn.net/younger_china/article/details/52175085

* https://github.com/kubernetes/examples/blob/master/staging/volumes/nfs/nfs-server-rc.yaml
