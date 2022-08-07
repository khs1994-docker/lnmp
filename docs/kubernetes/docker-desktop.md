# K8s on Docker Desktop

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

参考 `kubernetes/lnmp` 文件夹的说明进行部署。

## 相关项目

* https://github.com/AliyunContainerService/k8s-for-docker-desktop
