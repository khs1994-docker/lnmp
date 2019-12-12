# [local-path](https://github.com/rancher/local-path-provisioner)

**动态**

## 部署

```bash
$ kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

数据存放在 `/opt/local-path-provisioner`

## sc

```bash
$ kubectl get sc

local-path
```
