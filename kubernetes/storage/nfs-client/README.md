# [NFS-client](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client)

`PVC` 动态创建 `PV`

文件位于 `/exported/path/${namespace}-${pvcName}-${pvName}`，archive 文件位于 `/exported/path/archived-${namespace}-${pvcName}-${pvName}`

## 准备

* 已经拥有 NFSv4 服务端，这里假设为 `192.168.199.100`，部署时请 **务必** 替换为自己的地址。

## 安装依赖(重要)

```bash
$ sudo apt install -y nfs-common

$ sudo yum install -y nfs-utils
```

## 部署

在 `deploy/deploy.yaml` 将 `192.168.199.100` 替换为自己的 NFS 服务端地址，之后部署：

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
