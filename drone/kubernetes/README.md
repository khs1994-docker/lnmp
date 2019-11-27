# Drone + Gogs On Kubernetes

## 数据

数据存放于 hostPath `/var/lib/ci/XXX`，根据实际自行更改。

## 创建 ns

创建 k8s namespace

```bash
$ kubectl create ns ci
```

## MySQL

```bash
$ kubectl apply -n ci -k mysql
```

默认密码 `mytest`，手动进入创建 `gogs` `drone` `droneKubenative` 数据库 

## Redis

```bash
$ kubectl apply -n ci -k redis
```

## [Minio](https://github.com/helm/charts/tree/master/stable/minio)

```bash
$ kubectl apply -n ci -k minio
```

手动创建 `drone` `drone-kubenative` bucket

## Gogs

编辑 `config/gogs/app.kubernetes.ini` (内容从 `app.kubernetes.example.ini` 复制)

```bash
$ kubectl apply -n ci -k gogs
```

> 部署 Drone 1 2 任选其一（支持同时部署），新的 drone-kubenative 将任务作为 k8s 的 pod 运行。

## 1. [Drone](https://github.com/helm/charts/tree/master/stable/drone) + [Runner](https://docs.drone.io/installation/runners/)

```bash
$ kubectl apply -n ci -k drone

# $ kubectl apply -n ci -k drone/overlays/github
```

### [Docker runner](https://docker-runner.docs.drone.io/installation/install_linux/)

```bash
$ kubectl apply -n ci -k drone-runner/docker
```

### [Kubernetes runner](https://kube-runner.docs.drone.io/installation/installation/)

* 任务 pod 运行在 `drone-runner` 命名空间

```
$ kubectl apply -n ci -k drone-runner/kubernetes
```

## 2. Drone + kubenative

```bash
$ kubectl apply -n ci -k drone-kubenative
```

## ingress-nginx

后端 `gogs` `drone` `s3(minio)` 均为 http, 统一通过 ingress (https)代理访问(具体地址请到 `ingress-nginx/ingress-nginx.yaml` 查看)

```bash
$ kubectl apply -n ci -k ingress-nginx
```

## 私有仓库

`Registry` 自行在 Kubernetes 进行部署。

## ingress 证书为自签名证书

## 自定义

新建 `XXX/my-custom` 文件夹，基于 `base` 自定义（`$ kubectl kustomize`）。

```bash
$ kubectl apply -k XXX/my-custom

# $ kubectl apply -k drone/my-custom
```

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
