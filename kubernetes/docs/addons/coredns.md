# 部署 CoreDNS 插件

```bash
$ cd deployment

$ kubectl create -f addons/coredns.yaml

$ kubectl get all -n kube-system
```

## Test

```bash
$ kubectl run nginx --image=nginx:1.15.5-alpine

$ kubectl expose pod nginx

$ kubectl run nginx2 --image=nginx:1.15.5-alpine

$ kubectl exec nginx2 -i -t -- /bin/sh

root@nginx:/# cat /etc/resolv.conf

root@nginx:/# ping nginx
```
