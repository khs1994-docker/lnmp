# NFS Volume

**NFS 数据卷** 是跨主机的容器数据存储方案之一。

* https://github.com/ehough/docker-nfs-server

## .env 配置 IP 段

`NFS_EXPORT_N` 变量值为容器中 `/etc/exports` 中的每一行

部分设置项解释

```bash
/home/work 192.168.0.*（rw,sync,root_squash）  

rw：read-write，可读写;注意，仅仅这里设置成读写客户端还是不能正常写入，还要正确地设置共享目录的权限，参考问题7  
ro：read-only，只读；  
sync：文件同时写入硬盘和内存；  
async：文件暂存于内存，而不是直接写入内存；  
no_root_squash：NFS 客户端连接服务端时如果使用的是 root 的话，那么对服务端分享的目录来说，也拥有 root 权限。显然开启这项是不安全的。  
root_squash：NFS 客户端连接服务端时如果使用的是 root 的话，那么对服务端分享的目录来说，拥有匿名用户权限，通常他将使用 nobody 或 nfsnobody 身份；  
all_squash：不论 NFS 客户端连接服务端时使用什么用户，对服务端分享的目录来说都是拥有匿名用户权限；  
anonuid：匿名用户的 UID 值，通常是 nobody 或 nfsnobody，可以在此处自行设定；  
anongid：匿名用户的 GID 值。
```

## 加载内核模块

```bash
$ sudo modprobe {nfs,nfsd,rpcsec_gss_krb5}
```

## 容器运行 NFS 服务端

```bash
$ docker-compose up nfs # or $ lnmp-docker.sh nfs [down]
```

### k8s.gcr.io/volume-nfs:0.8

```bash
$ docker container run -it \
  -p 111:111 \
  -p 2049:2049 \
  -p 20048:20048 \
  -v $PWD:/nfs \
  --cap-add SYS_ADMIN \
  anjia0532/volume-nfs:0.8 \
  /nfs
```

* `--privileged`

## 系统安装 NFS 服务端

```bash
$ sudo apt install -y --no-install-recommends nfs-kernel-server kmod libcap2-bin
```

```bash
$ sudo yum install nfs-utils rpcbind

$ sudo systemctl start nfs
```

## NFS 客户端尝试挂载

* 客户端必须确保 RPC 协议相应的 portmap 正常运行，否则 mount 将失败

```bash
$ systemctl start rpcbind.service

$ showmount -e ${SERVER_IP:-192.168.199.100}

$ sudo mkdir /nfs

$ sudo mount -v -t nfs4 ${SERVER_IP:-192.168.199.100}:/nfs /nfs

$ mount
```

## 容器挂载 NFS Volume

```bash
$ docker container run -it --rm \
--mount 'type=volume,src=volume-nfs,dst=/data,volume-driver=local,volume-opt=type=nfs,volume-opt=device=192.168.199.100:/nfs,"volume-opt=o=addr=192.168.199.100,vers=4,soft,timeo=180,bg,tcp,rw"' busybox sh
```

## Compose 中使用 NFS volume

请查看 `docker-example.yml` 文件的 `volumes` 部分

## More Information

* https://blog.csdn.net/xuplus/article/details/51669063

* https://blog.csdn.net/ycnian/article/details/8515517
