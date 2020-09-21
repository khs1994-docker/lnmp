# docker buildx

* https://github.com/docker/buildx

## 创建实例

下载 `https://github.com/docker/buildx/releases`，放入 `~/.docker/cli-plugins/docker-buildx(.exe)`，并赋予可执行权限。

## 环境变量

必须设置如下环境变量才能使用 buildx

```bash
$ DOCKER_CLI_EXPERIMENTAL=enabled

# $env:DOCKER_CLI_EXPERIMENTAL="enabled"
```

### 国内环境使用如下命令

```bash
$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master

# kubernetes
# $ docker buildx create --use --name=mybuilder-k8s --driver kubernetes --driver-opt image=dockerpracticesig/buildkit:master
```

### 其他环境(国外/CI)使用如下命令

```bash
$ docker buildx create --use --name=mybuilder --driver docker-container
```

## Dockerfile ARG

```docker
# syntax=docker/dockerfile:experimental
ARG TARGETPLATFORM - platform of the build result. Eg linux/amd64, linux/arm/v7, windows/amd64.
ARG TARGETOS - OS component of TARGETPLATFORM
ARG TARGETARCH - architecture component of TARGETPLATFORM
ARG TARGETVARIANT - variant component of TARGETPLATFORM

ARG BUILDPLATFORM - platform of the node performing the build.
ARG BUILDOS - OS component of BUILDPLATFORM
ARG BUILDARCH - OS component of BUILDPLATFORM
ARG BUILDVARIANT - OS component of BUILDPLATFORM
```

## 构建镜像

```bash
$ docker buildx build ...
```

如何使用请参考以下链接

* https://vuepress.mirror.docker-practice.com/buildx/multi-arch-images.html
