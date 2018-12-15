# 使用自己构建的镜像

`.env` 文件更改以下变量

```bash
LNMP_SELF_BUILD_DOCKER_IMAGE_PREFIX=username
```

```bash
$ cd dockerfile/SOFT_NAME

$ cp example.Dockerfile Dockerfile

# 编辑 Dockerfile
$ vi Dockerfile

# 构建镜像
$ lnmp-docker build

# 启动
$ lnmp-docker build-up
```

## 部分服务使用自己镜像

在 `docker-compose.include.yml` 文件中重写 `image` 指令。
