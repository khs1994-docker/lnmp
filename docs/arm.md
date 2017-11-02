# ARM 架构

[arm32v7 Docker image](https://hub.docker.com/u/arm32v7/) 是树莓派 [官方系统 Raspbian (基于 Debian 9)](https://www.raspberrypi.org/downloads/raspbian/) 可以直接使用的。

[arm64v8 Docker image](https://hub.docker.com/u/arm64v8/) 即 arm 64位 架构在第三方系统（如 [Rancher OS](rancher.com/rancher-os)）可以使用，树莓派官方没有发布 arm 64位 系统。[pi64](https://github.com/bamarni/pi64) 可以安装 [Ubuntu arm64 位的 Docker](https://download.docker.com/linux/ubuntu/dists/xenial/pool/test/arm64/)。

注意 [armhf Docker image](https://hub.docker.com/u/armhf/) 已经废弃，已经转移到了上述两个项目中，更多信息请查看下边的参考链接。

## More Information

* https://github.com/docker-library/official-images#architectures-other-than-amd64
* [树莓派3 Docker 详解](https://www.khs1994.com/raspberry-pi3/docker.html)
