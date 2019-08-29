# docker buildx

* https://github.com/docker/buildx

## 创建实例

下载 `https://github.com/docker/buildx/releases`，放入 `~/.docker/cli-plugins/docker-buildx(.exe)`，并赋予可执行权限。

### 国内环境使用如下命令

```bash
$ docker buildx create --use --name=mybuilder --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master
```

### 其他环境使用如下命令

```bash
$ docker buildx create --use --name=mybuilder --driver docker-container
```
