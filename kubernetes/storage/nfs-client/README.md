# NFS-client

`PVC` 动态创建 `PV`

NFS 服务端路径 `/exported/path/${namespace}-${pvcName}-${pvName}`

## 准备

* 已经拥有 NFSv4 服务端 `192.168.199.100`

## 参考

* https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client
* docs/storage/nfs.md
