# K8s on Docker Desktop

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## gcr.io Local Server

修改 Hosts

```bash
127.0.0.1 k8s.gcr.io gcr.io
```

### macOS

需要在 Docker 设置中将 `gcr.io` `k8s.gcr.io` 加入到非安全仓库中。

### Windows

Windows 系统每次升级之后，k8s 可能一直处于启动状态中，请首先开启 Local Server，然后在设置中重置 Kubernetes。

### 拉取镜像

```bash
$ lnmp-docker gcr.io
```

## 故障排查

如果一直启动失败，可以删除以下文件夹之后重新启动 Docker

### Windows

* `~/.kube`
* `C:\ProgramData\DockerDesktop\pki`

## 切换

之前你可能使用了 `minikube`，使用以下命令切换到 Docker 桌面版。

```bash
$ kubectl config get-contexts

CURRENT   NAME                 CLUSTER                      AUTHINFO             NAMESPACE
          docker-desktop       docker-desktop               docker-desktop
*         minikube             minikube                     minikube

$ kubectl config use-context docker-desktop

# 切换回 minikube 的命令

$ kubectl config use-context minikube
```

## 部署 lnmp

启用 `k8s` 之后，输入如下命令

> 虽然 Docker 桌面版启用 k8s 之后可以使用 `docker stack` 命令进行部署，但是建议使用 `K8s` 的命令行 `kubectl` 进行部署。

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

## 相关项目

* https://github.com/AliyunContainerService/k8s-for-docker-desktop

## 开发者

> 本项目可能会更新不及时,你可以自行找出 `Docker 桌面版` 需要哪些 k8s.gcr.io 镜像

```bash
# 启动本地 gcr.io 服务器
$ lnmp-docker gcr.io --no-pull

# 查看日志
$ lnmp-docker gcr.io logs

# 根据日志找出 Docker 桌面版 会拉取哪些镜像,例如

# 在 `lnmp-docker(.ps1)` 中更新镜像(搜索 k8s.gcr.io)
```
