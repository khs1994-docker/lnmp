# 使用自己构建的镜像(对全部服务生效)

`.env` 文件更改以下变量

```bash
LNMP_BUILD_DOCKER_IMAGE_PREFIX=username

# LNMP_BUILD_DOCKER_IMAGE_PREFIX=domain.com/username
```

```bash
$ cd dockerfile/SOFT_NAME

$ cp example.Dockerfile Dockerfile

# 编辑 Dockerfile
$ vi Dockerfile

# 先构建镜像，若自定义镜像已存在，可不进行构建（跳过此步）
$ lnmp-docker build

# 启动
$ lnmp-docker build-up --no-build

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
