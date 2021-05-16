# Drone + Gogs On Kubernetes

## 数据

数据存放于 hostPath `/var/lib/k8s/ci/XXX`，根据实际自行更改。

## 创建 k8s namespace

```bash
$ kubectl create ns ci
```

## MySQL

```bash
$ kubectl apply -n ci -k mysql
```

默认密码 `mytest`，手动进入创建 `gogs` `drone` 数据库

```bash
$ kubectl get pod -n ci
# 保证处于 Running 状态，再执行以下命令
$ kubectl -n ci exec -it mysql-xxxx -- sh

$ mysql -uroot -pmytest

# mysql> create database db-name;
mysql> create database gogs;
mysql> create database drone;
```

## Redis

```bash
$ kubectl apply -n ci -k redis
```

## [Minio](https://github.com/helm/charts/tree/master/stable/minio)

```bash
$ kubectl apply -n ci -k minio
```

手动创建 `drone` bucket

## Gogs

编辑 `config/gogs/app.kubernetes.ini` (内容从 `app.kubernetes.example.ini` 复制)

```bash
$ kubectl apply -n ci -k gogs
```

## 部署 [Drone](https://github.com/helm/charts/tree/master/stable/drone) + [Runner](https://docs.drone.io/runner/overview/)

```bash
$ kubectl apply -n ci -k drone

# $ kubectl apply -n ci -k drone/providers/github
```

### 1.1 [Docker runner](https://docs.drone.io/runner/docker/installation/linux/)

```bash
$ kubectl apply -n ci -k drone-runner/docker
```

### 1.2 [Kubernetes runner](https://docs.drone.io/runner/kubernetes/installation/)

```
$ kubectl apply -n ci -k drone-runner/kubernetes
```

> 任务 pod 运行在 `drone-runner` 命名空间

## ingress-nginx

后端 `gogs` `drone` `s3(minio)` 均为 http, 统一通过 ingress (https) 代理访问(具体地址请到 `ingress-nginx/base/ingress-nginx.yaml` 查看)

```bash
$ kubectl apply -n ci -k ingress-nginx

$ kubectl apply -k ingress-nginx/ingress-tcp-22
```

## docker registry

`Registry` 自行在 Kubernetes 进行部署。

## 组件自定义

新建 `XXX/my-custom` 文件夹，基于 `base` 自定义（`$ kubectl kustomize`）。

```bash
$ kubectl apply -k XXX/my-custom

# $ kubectl apply -k drone/my-custom
```

## Drone 其他 provider

除了 `gogs` provider 外，还支持以下 provider:

* github
* gitea

`drone/providers/`

同时只能运行一个

### gitea

1. 参考 `MySQL` 一节，创建 `gitea` 数据库

2. 调整 `config/gitea/app.kubernetes.ini` 配置文件 (从 `app.kubernetes.example.ini` 复制)

3. 部署

```bash
$ kubectl apply -n ci -k gitea
```

## ingress 证书为自签名证书

### Drone git 克隆时跳过证书（SSL）验证

```diff
# .drone.yml
kind: pipeline
name: default2
type: kubernetes

# git 克隆时跳过证书验证
+ clone:
+   skip_verify: true
```

## 参考

* https://github.com/drone/charts
