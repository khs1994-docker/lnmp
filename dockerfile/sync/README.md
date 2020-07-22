# docker-image-sync

## 特色

* 支持同步 manifest
* 默认排除不常用的架构
* 不包含 Tag 时，则表示 Tag 为 latest，不表示同步全部 Tag

## 配置文件

```json
[
  {
    "source": "gcr.io/google-containers/pause:3.2",
    "dest": "registry.domain.com/namespace/pause:3.2"
  },
  {
    "source": "gcr.io/google-containers/coredns:1.7.0",
    "dest": "registry.domain.com/namespace/coredns:1.7.0"
  }
]
```

更多示例请查看 [docker-image-sync.json](docker-image-sync.json) 和 [docker-image-sync-by-docker.json](docker-image-sync-by-docker.json)

对于无命名空间的镜像（例如：`mcr.microsoft.com/powershell:preview-alpine-3.11`）无法解析(无法判定 `mcr.microsoft.com` 是命名空间还是仓库网址)，需要详细设置，请查看示例：https://github.com/khs1994-docker/lnmp/blob/master/windows/tests/docker-image-sync-test-full.json

**配置文件简化**

如果你的配置有公共部分，例如 **仓库地址** **命名空间** 可以对其简化

```bash
$SOURCE_DOCKER_REGISTRY=gcr.io
$SOURCE_NAMESPACE=google-containers

$DEST_DOCKER_REGISTRY=registry.domain.com
$DEST_NAMESPACE=namespace
```

设置以上环境变量之后，上面的示例配置文件可以简化为

```json
[
  {
    "source": "pause:3.2",
    "dest": "pause:3.2"
  },
  {
    "source": "coredns:1.7.0",
    "dest": "coredns:1.7.0"
  }
]
```

当 `source` 和 `dest` 一致时可以省略 `dest`

```json
[
  {
    "source": "pause:3.2"
  },
  {
    "source": "coredns:1.7.0"
  }
]
```

## 环境变量

* https://github.com/khs1994-docker/lnmp/blob/master/windows/docker-image-sync.Dockerfile

## 执行命令同步

> 适用于在 CI 中执行，推荐使用 https://coding.net/products/ci

在当前目录准备好名为 `docker-image-sync.json` 的配置文件。

如果你需要同步 Windows 镜像，请将 `-e SYNC_WINDOWS=false` 改为 `-e SYNC_WINDOWS=true`

```bash
$ docker run -i --rm \
      -e DEST_DOCKER_USERNAME=${DOCKER_USERNAME} \
      -e DEST_DOCKER_PASSWORD=${DOCKER_PASSWORD} \
      -e SOURCE_DOCKER_REGISTRY=mirror.ccs.tencentyun.com \
      -e DEST_DOCKER_REGISTRY=${DEST_DOCKER_REGISTRY} \
      -e DEST_NAMESPACE=${REGISTRY_NAMESPACE} \
      -e EXCLUDE_PLATFORM=true \
      -e SYNC_WINDOWS=false \
      -v $PWD/docker-image-sync.json:/docker-entrypoint.d/docker-image-sync.json \
      khs1994/docker-image-sync
```

如果你在 `Jenkins` 中运行此命令，可以参考 [Jenkinsfile](Jenkinsfile)

## 在 docker build 中同步

> 适用于没有 CI 的开发者，借用 docker build 来执行命令

请查看 [Dockerfile](Dockerfile) 文件

环境变量通过 `--build-arg K=V` 传入，构建参数请在 Docker 仓库的构建选项中配置。

**腾讯云**

* https://cloud.tencent.com/product/tke

在国外环境构建，无需配置

* [腾讯云 Docker 仓库](https://cloud.tencent.com/document/product/457/10152)

![](https://main.qcloudimg.com/raw/6e1a949c69b8df8e53e9811c128681ac.png)

在 **构建参数** 中点击 **新增变量**：

`DEST_DOCKER_USERNAME` -> `my_username`

依次类推，其他变量自行设置

**阿里云**

* https://www.aliyun.com/product/acr

在 **默认实例** 中新建镜像仓库

如果要同步国内访问不到的镜像（例如 `gcr.io`），请在配置中选择国外构建环境。如果仅同步 Docker Hub 中的镜像则国内国外均可。

阿里云不支持配置构建参数，请将仓库设为私有，在 Dockerfile 文件中设置 ARG

```diff
- ARG DEST_DOCKER_USERNAME
+ ARG DEST_DOCKER_USERNAME=my_username
```

依此类推，其他变量自行设置

## 注意事项

如果你的同步源是私有的并且每个源需要不同的凭证，你必须把凭证一致的写到一起，然后分开同步。

例如你需要同步 `registry1.com` 和 `registry2.com` 的私有镜像，并且两个仓库的凭证不一致，那么就不能在配置文件中写到一起：

```json
[
  {
    "source": "registry1.com/ns/x",
    "dest": "my_registry/ns/x"
  },
  {
    "source": "registry2.com/ns/y",
    "dest": "my_registry/ns/y"
  }
]
```

必须把它们分开，分别同步

```json
[
  {
    "source": "registry1.com/ns/x",
    "dest": "my_registry/ns/x"
  }
]
```

```json
[
  {
    "source": "registry2.com/ns/y",
    "dest": "my_registry/ns/y"
  }
]
```

对于目标仓库也是一样的。
