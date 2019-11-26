# [Local](https://kubernetes.io/docs/concepts/storage/volumes/#local)

通过 PV 控制器与 Scheduler 的结合，会对 local PV 做针对性的逻辑处理，从而，让 Pod 在多次调度时，能够调度到同一个 Node 上。

## 部署

```bash
$ sudo mkdir -p /data/pv
```

```bash
$ kubectl apply -k deploy
```

## 参考

* https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner
* https://www.jianshu.com/p/8236cb452bcf
* https://www.jianshu.com/p/bfa204cef8c0
* https://stor.51cto.com/art/201812/588905.htm
