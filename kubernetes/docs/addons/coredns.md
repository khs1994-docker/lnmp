# 部署 CoreDNS 插件

```bash
$ kubectl create -f addons/coredns.yaml

$ kubectl get all -n kube-system
```

## Test

```bash
$ kubectl run nginx --image=nginx:alpine

$ kubectl get pod

$ kubectl expose pod nginx-6b4b85b77b-sxskl --port 80

$ kubectl run nginx2 --image=nginx:alpine

$ kubectl get pod

$ kubectl exec nginx2-5f48f6bb64-gr5jk -i -t -- /bin/sh

root@nginx:/# cat /etc/resolv.conf

root@nginx:/# ping nginx
```
