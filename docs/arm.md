# ARM 架构

如果你手上有一个树莓派，那也可以很轻松的使用本项目，你同样只需执行以下命令(使用前 **建议** 阅读后续章节，做好准备工作)。

```bash
$ ./lnmp-docker up
```

> 建议使用 arm 64位系统 https://www.raspberrypi.com/software/operating-systems/

## MySQL 暂不支持 arm 32位

## [Docker ARM 镜像](https://github.com/docker-library/official-images#architectures-other-than-amd64)

|镜像|系统|架构|
|:--|:--|:--|
|[arm32v7 Docker image](https://hub.docker.com/u/arm32v7/)|[官方系统 Raspbian (基于 Debian)](https://www.raspberrypi.org/software/operating-systems/)|arm32|
|[arm64v8 Docker image](https://hub.docker.com/u/arm64v8/)|[pi 64](https://github.com/khs1994/pi64)|arm64|
|[armhf Docker image](https://hub.docker.com/u/armhf/)    |已经废弃，转移到了上述两个项目中|-|

## ARM 镜像构建

请查看 [buildx](buildx.md) 或 [manifest](manifest.md)

## 参考

* [树莓派3 安装 Docker](https://blog.khs1994.com/raspberry-pi3/docker.html)
* https://github.com/docker-library/official-images#architectures-other-than-amd64
