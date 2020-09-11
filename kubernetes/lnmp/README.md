# LNMP

**部署 PV**

```bash
# 适用于 Linux
$ kubectl kustomize storage/pv/linux | sed "s/__USERNAME__/$(whoami)/g" | kubectl apply -f -

# 适用于 macOS Docker Desktop k8s
$ kubectl kustomize storage/pv/macos | sed "s/__USERNAME__/$(whoami)/g" | kubectl apply -f -

# 适用于 Windows Docker Desktop k8s
$ (kubectl kustomize storage/pv/windows).replace('__USERNAME__',$env:USERNAME) | kubectl apply -f -

# nfs
$ kubectl kustomize storage/pv/nfs | sed "s/192.168.199.100/YOUR_NFS_SERVER/g" | kubectl apply -f -

# production 环境请将 storage 替换为 storage-production
```

**创建 NS**

```bash
$ kubectl create ns lnmp

# production
# $ kubectl create ns lnmp-production
```

**部署 PVC**

```bash
$ kubectl apply -k storage/pvc/hostpath -n lnmp

# nfs pvc
# $ kubectl apply -k storage/pvc/nfs

# production
# $ kubectl apply -k storage-production/pvc/hostpath -n lnmp-production
```

**Redis**

```bash
$ kubectl apply -k redis/overlays/development -n lnmp

# production
# $ kubectl apply -k redis/overlays/production -n lnmp-production
```

**mysql**

```bash
$ kubectl apply -k mysql/overlays/development -n lnmp

# production
# $ kubectl apply -k mysql/overlays/production -n lnmp-production
```

**PHP**

```bash
$ kubectl apply -k php/overlays/development -n lnmp

# production
# $ kubectl apply -k php/overlays/production -n lnmp-production
```

**NGINX**

```bash
$ kubectl apply -k nginx/overlays/development -n lnmp

$ kubectl apply -k nginx/overlays/nodePort -n lnmp

# production
# $ kubectl apply -k nginx/overlays/production -n lnmp-production

# $ kubectl apply -k nginx/overlays/nodePort -n lnmp-production
```

## 计划任务

> 例如，Laravel 调度器 Schedule

```bash
$ kubectl apply -f cronJob/deploy.yaml
```

## 测试

请查看 `nginx/overlays/development/config/conf.d` 中 nginx 配置的网址，自行访问测试。

## 清理

```bash
$ kubectl delete ns lnmp
$ kubectl delete pv -l app=lnmp -l env=development

# production
# $ kubectl delete ns lnmp-production
# $ kubectl delete pv -l app=lnmp -l env=production
```
