# NFS Volume

## 容器运行 NFS 服务端

```bash
$ docker-compose up nfs
```

## WSL 运行 NFS 服务端

```bash
$ sudo apt-get install -y --no-install-recommends nfs-kernel-server kmod libcap2-bin


```

## 容器挂载 NFS Volume

```bash
$ docker container run -it --rm \
--mount 'type=volume,src=volume-nfs,dst=/data,volume-driver=local,volume-opt=type=nfs,volume-opt=device=192.168.199.100:/nfs,"volume-opt=o=addr=192.168.199.100,vers=4,soft,timeo=180,bg,tcp,rw"' busybox sh
```
