# [CSI hostpath](https://github.com/kubernetes-csi/csi-driver-host-path)

## 部署

```bash
$ kubectl apply -k deploy
```

## RBAC

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-provisioner/v1.0.1/deploy/kubernetes/rbac.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-attacher/v1.0.1/deploy/kubernetes/rbac.yaml

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v1.0.1/deploy/kubernetes/rbac.yaml

```
