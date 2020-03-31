# ARM 架构

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

如果你手上有一个树莓派，那也可以很轻松的使用本项目，你同样只需执行以下命令(使用前 **建议** 阅读后续章节，做好准备工作)。

```bash
$ ./lnmp-docker up
```

## arm 暂不支持 MySQL、PHPMyAdmin

* 在 `.env` 文件中将 `mysql` 替换为 `mariadb`
* 在 `.env` 文件中将 `phpmyadmin` 去掉
* 在 `.env` 文件中 `LREW_INCLUDE` 新增 `mariadb`

```diff
- LNMP_SERVICES="nginx mysql php7 redis phpmyadmin"
+ LNMP_SERVICES="nginx mariadb php7 redis"

- LREW_INCLUDE="pcit"
+ LREW_INCLUDE="pcit mariadb"
```

## 安装 docker-compose

**依赖软件**

```bash
$ sudo apt install libffi-dev
```

## [Docker ARM 镜像](https://github.com/docker-library/official-images#architectures-other-than-amd64)

|镜像|系统|架构|
|:--|:--|:--|
|[arm32v7 Docker image](https://hub.docker.com/u/arm32v7/)|[官方系统 Raspbian (基于 Debian)](https://www.raspberrypi.org/downloads/raspbian/)|arm32|
|[arm64v8 Docker image](https://hub.docker.com/u/arm64v8/)|[pi 64](https://github.com/khs1994/pi64)|arm64|
|[armhf Docker image](https://hub.docker.com/u/armhf/)    |已经废弃，已经转移到了上述两个项目中|-|

## ARM 镜像构建

请查看 [buildx](buildx.md) 或 [manifest](manifest.md)

## ARM64

由于 [bamarni/pi64](https://github.com/bamarni/pi64) 不再更新,笔者 [fork](https://github.com/khs1994/pi64) 了此项目并持续更新.

## 参考

* [树莓派3 安装 Docker](https://blog.khs1994.com/raspberry-pi3/docker.html)
* https://github.com/docker-library/official-images#architectures-other-than-amd64
