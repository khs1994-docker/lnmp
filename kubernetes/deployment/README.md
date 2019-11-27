# YAML 部署文件

这些 YAML 文件仅供参考，**建议** 将其作为 `bases`，通过 `$ kubectl kustomize` 自定义之后部署。

```bash
$ kubectl apply -k path/SOFT/my-custom`.
```

> 如何自定义可以参考 `mysql/custom` 文件夹

### 开发环境 development 特殊配置文件

* `conf.d/*.conf` configMap/nginx-conf-d/*.conf
* `configMap` lnmp-configMap.development.yaml
* `secret` lnmp-secret.development.yaml

## 端口映射

### 开发环境 development

* `docker desktop` LoadBalancer 80/443
* `linux` NodePort 80 443

### 生产环境

`NodePort` 80 443 随机映射

### ingress

自行部署

## 数据卷

## 开发环境 development

### NFS

* NFS `PVC` 及对应 `PV` 均为手工声明

### hostpath `--no-nfs`

* `~/app-development`
* `~/.docker/Volumes/lnmp-XXX-data-development`

## 生产环境 production

### NFS

* NFS `PVC` 动态创建 NFS `PV`,具体参考 `storage/nfs-client`

### hostpath `--no-nfs`

* `~/app-production`
* `~/.docker/Volumes/lnmp-XXX-data-production`

## 计划任务

> 例如，Laravel 调度器 Schedule

```bash
$ kubectl create -f lnmp-cronjob.yaml
```
