# ARM 架构

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

如果你手上有一个树莓派，那也可以很轻松的使用本项目，你同样只需执行以下命令。

```bash
$ ./lnmp-docker up
```

## arm 暂不支持 MySQL、PHPMyAdmin

* 请在 `.env` 文件中将 mysql 替换为 mariadb
* 请在 `.env` 文件中将 phpmyadmin 去掉

```diff
- LNMP_SERVICES="nginx mysql php7 redis phpmyadmin"

+ LNMP_SERVICES="nginx mariadb php7 redis"
```

## Docker ARM 镜像

|镜像|系统|架构|
|:--|:--|:--|
|[arm32v7 Docker image](https://hub.docker.com/u/arm32v7/)|[官方系统 Raspbian (基于 Debian 9)](https://www.raspberrypi.org/downloads/raspbian/)|arm32|
|[arm64v8 Docker image](https://hub.docker.com/u/arm64v8/)|[pi 64](https://github.com/khs1994/pi64)|arm64|
|[armhf Docker image](https://hub.docker.com/u/armhf/)    |已经废弃，已经转移到了上述两个项目中|-|

## 镜像构建

请查看 [manifest](manifest.md)

## More Information

* [树莓派3 安装 Docker](https://blog.khs1994.com/raspberry-pi3/docker.html)
* https://github.com/docker-library/official-images#architectures-other-than-amd64

## ARM64

由于 [bamarni/pi64](https://github.com/bamarni/pi64) 不再更新,我 [fork](https://github.com/khs1994/pi64) 了此项目并持续更新.
