# [dockerpracticesig/buildkit:master](https://github.com/moby/buildkit/releases)

```bash
# 添加了镜像设置，建议在国内环境使用
# 网易云镜像 二选一
$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master

# 百度云镜像 二选一
$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master-baidu

# 默认
$ docker buildx create --use --name=mybuilder --driver docker-container
```

## 云环境内使用

**腾讯云**

```bash
$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master-tencent
```
