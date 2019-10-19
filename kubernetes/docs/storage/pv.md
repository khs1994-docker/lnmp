# PV

`PVC` 和 `PV` 的绑定，不是简单的通过 `Label` 来进行。而是要综合 `storageClassName` `accessModes` `matchLabels` 以及 `storage`

## 静态创建 PV

创建一个 PVC 就必须手动去创建一个 PV

## [动态创建 PV](https://kubernetes.io/zh/docs/concepts/storage/dynamic-provisioning/)

动态存储卷供应使用 `StorageClass` 进行实现，其允许存储卷按需被创建。如果没有动态存储供应，Kubernetes 集群的管理员将不得不通过手工的方式类创建新的存储卷。通过动态存储卷，Kubernetes 将能够按照用户的需要，自动创建其需要的存储。

## storageClassName

In the past, the annotation `volume.beta.kubernetes.io/storage-class` was used instead of the `storageClassName` attribute. This annotation is still working; however, it will become fully deprecated in a future Kubernetes release

## PV type

* https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes

## 参考

* https://www.cnblogs.com/cuishuai/p/9152277.html
