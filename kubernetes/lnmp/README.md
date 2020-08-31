# LNMP

**部署 PV**

```bash
$ kubectl kustomize storage/pv/linux | sed "s/__USERNAME__/$(whoami)/g" | kubectl apply -f -

# 适用于 macOS Docker Desktop k8s
$ kubectl kustomize storage/pv/macos | sed "s/__USERNAME__/$(whoami)/g" | kubectl apply -f -

# 适用于 Windows Docker Desktop k8s
$ (kubectl kustomize storage/pv/windows).replace('__USERNAME__',$env:USERNAME) | kubectl apply -f -

# nfs
$ kubectl kustomize storage/pv/nfs | sed "s/192.168.199.100/YOUR_NFS_SERVER/g" | kubectl apply -f -
```

**创建 NS**

```bash
$ kubectl create ns lnmp
```

**部署 PVC**

```bash
$ kubectl apply -k storage/pvc/hostpath -n lnmp

# $ kubectl apply -k storage/pvc/nfs
```

**Redis**

```bash
$ kubectl apply -k redis/overlays/development -n lnmp
```

**mysql**

```bash
$ kubectl apply -k mysql/overlays/development -n lnmp
```

**PHP**

```bash
$ kubectl apply -k php/overlays/development -n lnmp
```

**NGINX**

```bash
$ kubectl apply -k nginx/overlays/development -n lnmp

$ kubectl apply -k nginx/overlays/nodePort -n lnmp
```

## 计划任务

> 例如，Laravel 调度器 Schedule

```bash
$ kubectl apply -f cronJob/deploy.yaml
```

## 测试

请查看 `nginx/overlays/development/config/conf.d` 中 nginx 配置的网址。
