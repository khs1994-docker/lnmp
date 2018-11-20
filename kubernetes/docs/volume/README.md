# Volumes

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

# Tips

* 静态提供：管理员手动创建多个PV，供PVC使用。

* 动态提供：动态创建PVC特定的PV，并绑定。
