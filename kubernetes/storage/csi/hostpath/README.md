# [CSI hostpath](https://github.com/kubernetes-csi/csi-driver-host-path)

**动态**

**仅适用于 v1.18.x**

## CRD

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
```

## 部署

```bash
$ kubectl apply -k deploy
```

数据存放于 `/var/lib/csi-hostpath-data/`，在 `csi-hostpath-plugin.yaml` 定义

## RBAC

```bash
$ curl -L https://raw.githubusercontent.com/kubernetes-csi/external-attacher/v3.0.0/deploy/kubernetes/rbac.yaml -o deploy/rbac/attacher.yaml

$ curl -L https://raw.githubusercontent.com/kubernetes-csi/external-provisioner/v2.0.2/deploy/kubernetes/rbac.yaml -o deploy/rbac/provisioner.yaml

$ curl -L https://raw.githubusercontent.com/kubernetes-csi/external-resizer/v1.0.0/deploy/kubernetes/rbac.yaml -o deploy/rbac/resizer.yaml

$ curl -L https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v3.0.0/deploy/kubernetes/csi-snapshotter/rbac-csi-snapshotter.yaml -o deploy/rbac/snapshotter.yaml
```

## 问题

* 节点重启之后，pod 绑定不到 pvc

## 参考

* https://juejin.cn/post/6844903689946136584
