# Docker 常用镜像站点

## docker.io

> 有时部分镜像可能不可用，请尝试另一个即可。

* `https://hub-mirror.c.163.com`
* `https://mirror.baidubce.com`
* `https://docker.mirrors.ustc.edu.cn`

## k8s.gcr.io

国内阿里云容器仓库同步了部分 `k8s.gcr.io` 的镜像：

```bash
$ docker pull k8s.gcr.io/pause:3.2

# 你想获取 k8s.gcr.io/pause:3.2 镜像，可以使用下面的命令

$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2
```

## quay.io

## mcr.microsoft.com

* https://github.com/microsoft/containerregistry/blob/main/docs/mcr-endpoints-guidance.md
