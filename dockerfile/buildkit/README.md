# dockerpracticesig/buildkit:master

针对国内环境优化 `moby/buildkit:master` 镜像，用于 `$ docker buildx create` 命令。

```bash
# $ docker buildx create --use --name=mybuilder --driver docker-container

$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master
```
