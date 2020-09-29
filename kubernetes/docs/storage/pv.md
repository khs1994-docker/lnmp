# PersistentVolume（持久化卷 PV）

* https://github.com/kubernetes-retired/external-storage

* PV 是 **全局** 的,没有命名空间的概念。

```bash
$ kubectl get storageclass
```

`PersistentVolumes` 可以有多种回收策略，包括 **Retain**、**Recycle** 和 **Delete**。对于动态配置的 `PersistentVolumes` 来说，默认回收策略为 **Delete**。这表示当用户删除对应的 `PersistentVolumeClaim` 时，动态配置的 volume 将被自动删除。

如果 volume 包含重要数据时，这种自动行为可能是不合适的。那种情况下，更适合使用 **Retain** 策略。使用 **Retain** 时，如果用户删除 `PVC`，对应的 `PV` 不会被删除。相反，它将变为 **Released** 状态，表示所有的数据可以被手动恢复。

## PV 回收策略

* **Retain** 就是保留现场，K8S 什么也不做，允许人工处理保留的数据

* **Delete** K8S会自动删除该 PV 及里面的数据

* **Recycle** K8S会将 PV 里的数据删除，然后把 PV 的状态变成 Available，又可以被新的 PVC 绑定使用

* NFS 和 HostPath 支持回收 **Recycle**

* AWS、EBS、GCE、PD 和 Cinder 支持删除 **Delete**。

## 状态位清除

```bash
$ kubectl replace -f xxx.yaml # 定义 PV 的 YAML 文件
```

## Tips

* 静态提供：管理员手动创建多个PV，供PVC使用。

* 动态提供：动态创建PVC特定的PV，并绑定。

`PVC` 和 `PV` 的绑定，不是简单的通过 `Label` 来进行。而是要综合 `storageClassName` `accessModes` `matchLabels` 以及 `storage`

## 静态创建 PV

创建一个 PVC 就必须手动去创建一个 PV

## [动态创建 PV](https://kubernetes.io/zh/docs/concepts/storage/dynamic-provisioning/)

动态存储卷供应使用 `StorageClass` 进行实现，其允许存储卷按需被创建。如果没有动态存储供应，Kubernetes 集群的管理员将不得不通过手工的方式类创建新的存储卷。通过动态存储卷，Kubernetes 将能够按照用户的需要，自动创建其需要的存储。

## storageClassName

In the past, the annotation `volume.beta.kubernetes.io/storage-class` was used instead of the `storageClassName` attribute. This annotation is still working; however, it will become fully deprecated in a future Kubernetes release

## PV type

* https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes

## PV 生命周期

`available` 表示当前的 pv 没有被绑定
`bound` 已经被 pvc 挂载
`released` pvc 没有在使用 pv, 需要管理员手工释放 pv
`failed` 资源回收失败

| 操作 | PV状态 | PVC状态 |
| --   | -- | --|
|1. 添加 PV                  | Available | - |
|2. 添加 PVC                 | Available | Pending |
|                           | Bound | Bound |
|3. 删除 PV                   | - | Lost|
|4. 再次添加 PV               | Bound | Bound|
|5. 删除 PVC                  | Released | - |
|6. Storage 不可用            | Failed | - |
|7. 手动修改PV，删除 ClaimRef | Available | - |

## 参考

* https://www.cnblogs.com/cuishuai/p/9152277.html
* https://blog.csdn.net/dkfajsldfsdfsd/article/details/81319735
