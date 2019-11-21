# Drone + Gogs On Kubernetes

* 数据存放于 hostPath `/var/lib/ci/XXX`，根据实际自行更改。

创建 k8s namespace

```bash
$ kubectl create ns ci
```

## 数据库服务、缓存服务

### MySQL

```bash
$ kubectl apply -n ci -k mysql
```

默认密码 `mytest`，手动进入创建 **gogs** **drone** **droneKubenative** 数据库 

### Redis

```bash
$ kubectl apply -n ci -k redis
```

## Gogs

编辑 `config/gogs/app.kubernetes.ini` (内容从 `app.kubernetes.example.ini` 复制)

```bash
$ kubectl apply -n ci -k gogs
```

> 部署 Drone 1 2 任选其一（支持同时部署），新的 drone-kubenative 将任务作为 k8s 的 pod 等运行。

## 1. Drone + Runner

```bash
$ kubectl apply -n ci -k drone
```

* https://docs.drone.io/installation/runners/

### Docker runner

```bash
$ kubectl apply -n ci -k drone-runner/docker
```

### Kubernetes runner

* 命名空间为 `drone-runner`

```
$ kubectl apply -n ci -k drone-runner/kubernetes
```

## 2. Drone + kubenative

```bash
$ kubectl apply -n ci -k drone-kubenative
```

## ingress-nginx

后端 `gogs` `drone` 均为 http, 统一通过 ingress 代理访问(具体地址请到 `ingress-nginx/ingress-nginx.yaml` 查看)

```bash
$ kubectl apply -n ci -k ingress-nginx
```

## 私有仓库

`Registry` 自行在 Kubernetes 进行部署。

## 自签名证书

### git 克隆时跳过证书验证

```diff
# .drone.yml
kind: pipeline
name: default2
type: kubernetes

# git 克隆时跳过证书验证
+ clone:
+   skip_verify: true
```
