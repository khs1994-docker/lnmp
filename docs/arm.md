# ARM 架构

如果你手上有一个树莓派，那也可以很轻松的使用本项目，你只需执行以下命令。

```bash
$ ./lnmp-docker.sh development
```

该脚本会识别出您使用的是树莓派，并拉取专用的 Docker 镜像。

# Docker ARM 镜像

[arm32v7 Docker image](https://hub.docker.com/u/arm32v7/) 是树莓派 [官方系统 Raspbian (基于 Debian 9)](https://www.raspberrypi.org/downloads/raspbian/) 可以直接使用的。

[arm64v8 Docker image](https://hub.docker.com/u/arm64v8/) 即 `arm64` 架构在第三方系统（如 [pi 64](https://github.com/bamarni/pi64)）可以使用，树莓派官方没有发布 arm 64位 系统。[pi64](https://github.com/bamarni/pi64) 可以安装 [Ubuntu arm64 位的 Docker](https://download.docker.com/linux/ubuntu/dists/xenial/pool/test/arm64/)。

注意 [armhf Docker image](https://hub.docker.com/u/armhf/) 已经废弃，已经转移到了上述两个项目中，更多信息请查看下边的参考链接。

## More Information

* [树莓派3 安装 Docker](https://www.khs1994.com/raspberry-pi3/docker.html)
* https://github.com/docker-library/official-images#architectures-other-than-amd64
