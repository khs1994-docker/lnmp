# Docker 桌面版支持 k8s

* 由于国内网络问题，本项目提供了 `k8s.gcr.io` `gcr.io` Local Docker Registry Server

```bash
$ cd ..

$ ./lnmp-docker gcr.io
```

具体请查看 https://github.com/khs1994-docker/lnmp/issues/520

## 切换

之前你可能使用了 minikube 使用以下命令切换到 Docker 桌面版。

```bash
$ kubectl config get-contexts

CURRENT   NAME                 CLUSTER                      AUTHINFO             NAMESPACE
          docker-for-desktop   docker-for-desktop-cluster   docker-for-desktop
*         minikube             minikube                     minikube

$ kubectl config use-context docker-for-desktop

# 切换回 minikube 的命令

$ kubectl config use-context minikube
```

### 部署 lnmp

启用 `k8s` 之后，输入如下命令

> 虽然 Docker 桌面版启用 k8s 之后可以使用 `docker stack` 部署，但是我这里建议使用原生的 `kubectl` 进行部署。

```bash
$ lnmp-k8s create
```

### 删除 lnmp

```bash
$ lnmp-k8s delete
```

### 销毁 lnmp

```bash
$ lnmp-k8s cleanup
```
