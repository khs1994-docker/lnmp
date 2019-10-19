# YAML 部署文件

这些 YAML 文件仅供参考，**建议** 将其复制到其他目录,自行更改后,自行部署 `$ kubectl apply -k path/SOFT/overlays/ENVIRONMENT`.

## 配置文件

配置文件位于 `SOFT/overlays/ENVIRONMENT/config`

## 自定义配置文件

`SOFT/overlays/ENVIRONMENT/config/*.custom.*`

并修改 `SOFT/overlays/ENVIRONMENT/kustomization.yaml` 文件,例如

```diff
configMapGenerator:
...
  files:
+  - docker.cnf=config/docker.custom.cnf
-  # - docker.cnf=config/docker.production.cnf
```

## 数据卷

## 开发环境 development

* NFS `PVC` 及对应 `PV` 均为手工声明

## 生产环境 production

* NFS `PVC` 动态创建 NFS `PV`,具体参考 `storage/nfs-client`

```bash
$ kubectl apply -f storage/nfs-client
```

## 计划任务

> 例如，Laravel 调度器 Schedule

```bash
$ kubectl create -f lnmp-cronjob.yaml
```
