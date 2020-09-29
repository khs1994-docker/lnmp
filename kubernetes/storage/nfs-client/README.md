# [NFS-client](https://github.com/kubernetes-retired/external-storage/tree/master/nfs-client)

**动态**

文件位于 `/exported/path/${namespace}-${pvcName}-${pvName}`，archive 文件位于 `/exported/path/archived-${namespace}-${pvcName}-${pvName}`

## 部署 NFS 服务端

> 如果你已经拥有 NFSv4 服务端，请跳过此步。

```bash
$ kubectl apply -k ../../deploy/nfs-server
```

## 安装依赖(重要)

```bash
$ sudo apt install -y nfs-common

$ sudo yum install -y nfs-utils
```

## 部署

> 如果你使用的是你自己的 NFS 服务器，请在 `deploy/deploy.yaml` 搜索 `fix me` 将值替换为实际的值。

```bash
$ kubectl apply -f deploy
```

## 测试

```bash
$ kubectl apply -f tests
```

进入 pod 的 `/data` 目录新建文件，并在 NFS 服务端查看文件是否存在。

## 参考

* docs/storage/nfs.md
