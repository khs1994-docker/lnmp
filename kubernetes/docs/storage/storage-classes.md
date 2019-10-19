# [Storage-Classes](https://kubernetes.io/zh/docs/concepts/storage/storage-classes/)

`StorageClass` 标记存储资源的特性和性能, 在 1.6 版本, `StorageClass` 与动态资源供应的机制得到了完善, 实现了存储卷的按需创建

每个 `StorageClass` 都包含 `provisioner`、`parameters` 和 `reclaimPolicy` 字段， 这些字段会在 `StorageClass` 需要动态分配 `PersistentVolume` 时会使用到
