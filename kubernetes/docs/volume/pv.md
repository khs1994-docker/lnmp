# PV

`pvc` 绑定到对应 `pv` 通过 labels 标签方式实现，也可以不指定，将随机绑定到 pv。

## 静态创建 PV

创建一个 PVC 就必须手动去创建一个 PV

## 动态创建 PV

动态存储卷供应使用 `StorageClass` 进行实现，其允许存储卷按需被创建。如果没有动态存储供应，Kubernetes 集群的管理员将不得不通过手工的方式类创建新的存储卷。通过动态存储卷，Kubernetes 将能够按照用户的需要，自动创建其需要的存储。

## 参考

* https://www.cnblogs.com/cuishuai/p/9152277.html
