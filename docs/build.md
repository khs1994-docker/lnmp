# 使用自己的镜像(对全部服务生效)

`.env` 文件更改以下变量

```bash
LNMP_BUILD_DOCKER_IMAGE_PREFIX=username

# LNMP_BUILD_DOCKER_IMAGE_PREFIX=domain.com/username
```

## 构建（或拉取）镜像

**1. 构建镜像**

```bash
$ cd dockerfile/SOFT_NAME

$ cp example.Dockerfile Dockerfile

# 编辑 Dockerfile
$ vi Dockerfile

$ lnmp-docker build
```

**2. 拉取镜像**

```bash
$ lnmp-docker build-pull
```

## 启动

```
# 默认加入了 --no-build 参数，必须保证执行 build-up 前镜像已经存在，具体请参考上面的内容
$ lnmp-docker build-up

# 测试
$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.06 x86_64 With Build Docker Image

development
```

# 使用自己的镜像(除使用官方镜像的服务以外)

`.env` 文件更改以下变量

```bash
# LNMP_DOCKER_IMAGE_PREFIX=khs1994

LNMP_DOCKER_IMAGE_PREFIX=username
```

## 部分服务使用自己镜像

在 `docker-lnmp.include.yml` 文件中重写对应服务的 `image` 指令。
