# YAML 部署文件

这些 YAML 文件仅供参考，**建议** 将其复制到其他目录,自行更改后,自行部署 `$ kubectl apply -k path/SOFT/overlays/ENVIRONMENT`.

## 配置文件

配置文件位于 `SOFT/overlays/ENVIRONMENT/config`

## 自定义配置文件

## 数据卷

## 生产环境

* NFS `PVC` 动态创建 NFS `PV`,具体参考 `csi/nfs-client`

```bash
$ kubectl apply -f csi/nfs-client
```

## 计划任务

> 例如，Laravel 调度器 Schedule

```bash
$ kubectl create -f lnmp-cronjob.yaml
```
