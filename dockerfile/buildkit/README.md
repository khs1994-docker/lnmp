# [dockerpracticesig/buildkit:master](https://github.com/moby/buildkit/releases)

```bash
# 添加了镜像设置，建议在国内环境使用
$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master

$ docker buildx create --use --name=mybuilder --driver docker-container
```
