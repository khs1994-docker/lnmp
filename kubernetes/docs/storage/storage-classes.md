# [Storage-Classes](https://kubernetes.io/zh/docs/concepts/storage/storage-classes/)

每个 `StorageClass` 都包含 `provisioner`、`parameters` 和 `reclaimPolicy` 字段， 这些字段会在 `StorageClass` 需要动态分配 `PersistentVolume` 时会使用到。
