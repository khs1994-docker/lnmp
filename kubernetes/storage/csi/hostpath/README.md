# [CSI hostpath](https://github.com/kubernetes-csi/csi-driver-host-path)

**动态**

## 部署

```bash
$ kubectl apply -k deploy
```

数据存放于 `/var/lib/csi-hostpath-data/`，在 `csi-hostpath-plugin.yaml` 定义

## RBAC

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-attacher/v2.0.0/deploy/kubernetes/rbac.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-provisioner/v1.4.0/deploy/kubernetes/rbac.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-resizer/v0.3.0/deploy/kubernetes/rbac.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v1.2.0/deploy/kubernetes/rbac.yaml

```

## 参考

* https://juejin.im/post/5bc07abc6fb9a05d2a1d92b3
* https://blog.51cto.com/14051317/2368383
