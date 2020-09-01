# K8s on Docker Desktop

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## gcr.io Local Server

修改 Hosts

```bash
127.0.0.1 k8s.gcr.io gcr.io
```

### 拉取镜像

```bash
$ lnmp-docker gcr.io
```

## 故障排查

如果一直启动失败，可以删除以下文件夹之后重新启动 Docker

### Windows

* `~/.kube`
* `$home\AppData\Local\Docker\pki`

## 切换 context

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

参考 `kubernetes/lnmp` 文件夹的说明进行部署。

## 相关项目

* https://github.com/AliyunContainerService/k8s-for-docker-desktop

## 开发者

> 本项目可能会更新不及时，你可以自行找出 `Docker 桌面版` 需要哪些 k8s.gcr.io 镜像

```bash
# 启动本地 gcr.io 服务器
$ lnmp-docker gcr.io --no-pull

# 在 docker 设置中启用 k8s
# 查看日志
$ lnmp-docker gcr.io logs

# 根据日志找出 Docker 桌面版 会拉取哪些镜像,例如
ERRO[0285] response completed with error                 err.code="manifest unknown" err.detail="unknown tag=v1.18.3" err.message="manifest unknown" go.version=go1.11.2 http.request.host=k8s.gcr.io http.request.id=ec12c017-08cf-46cc-8780-22c351d8712b http.request.method=GET http.request.remoteaddr="172.17.0.1:37926" http.request.uri="/v2/kube-apiserver/manifests/v1.18.3" http.request.useragent="docker/19.03.12 go/go1.13.10 git-commit/48a66213fe kernel/5.8.0-rc3-microsoft-standard os/linux arch/amd64 UpstreamClient(Go-http-client/1.1)" http.response.contenttype="application/json; charset=utf-8"
 http.response.duration=207.384ms http.response.status=404 http.response.written=97 vars.name=kube-apiserver vars.reference=v1.18.3

# 此日志说明需要 k8s.gcr.io/kube-apiserver:v1.18.3
# 在 `lnmp-docker(.ps1)` 中更新镜像(搜索 k8s.gcr.io)
```
