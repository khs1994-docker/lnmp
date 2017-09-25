# LNMP Docker

[![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)]() [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=dev)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/lnmp.svg)]() [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)]()

项目目标：使用 Docker Compose 快速搭建 LNMP 环境。

项目初衷：搭建一个 LNMP 环境（不知道为什么我不喜欢 apt yum 来安装 LNMP,也没有用过一键安装脚本）需要手动下载 LNMP 源码包，安装依赖包，编译，编译出错再安装依赖包，再修改默认配置，这样一个过程差不多半天过去了。Docker 的优点是轻量、跨平台、提供一致的环境（避免在我这里行换到你那就不行的问题），我之前一直使用 `docker run` 来使用 Docker，问题是启动一个容器需要写参数、环境变量、挂载文件目录等，造成命令的繁杂，不易读，之后我就将 `docker run ...` 写入脚本文件，通过运行脚本文件来启动Docker。接触 Docker Compose 之后把原来的项目（哪怕是一个容器）也写成 `docker-compose.yml` 来使用 Docker，Docker Compose 是一种容器编排工具，说人话就是管理多个容器的工具，以启动 LNMP（包括 Redis ） 为例，使用 `docker run` 你需要执行四条命令，而使用 Docker Compose 你只需执行 `docker-compose up -d` 就把四个容器全部启动了，这还不包括停止容器，容器依赖方式等操作。此项目是给大家提供一种思路，也是本人对 Docker 的实践，也为了学习使用 Git 来管理项目。

# 更新记录

每季度（17.09，17.12，18.03...）更新版本，版本命名方式为 `YY-MM`，更新记录请查看 [Releases](https://github.com/khs1994-docker/lnmp/releases)，查看最新提交请切换到 [dev 分支](https://github.com/khs1994-docker/lnmp/tree/dev)。

# 准备

本项目需要以下软件：

* Docker CE

* Docker Composer

# 项目说明

本项目支持 `x86_64` 架构的 Linux, macOS, Windows 10 (PC)，并且支持 `armhf` 架构的 Debian。

## 包含软件

* Nginx
* MySQL
* PHP7
* PHP7-FPM
* Laravel
* Laravel artisan
* Composer
* Redis
* Memcached
* MongoDB
* PostgreSQL
* RabbitMQ

## 文件夹结构

|文件夹|说明|
|:--|:--|
|`app`         |项目文件（HTML,PHP,etc）「位于[Git 子模块](https://git-scm.com/book/zh/v1/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)」|
|`config`      |配置文件 「nginx 配置文件位于[Git 子模块](https://git-scm.com/book/zh/v1/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)」|               
|`dockerfile`  |自定义 Dockerfile|
|`logs`        |日志文件|
|`var`         |数据文件|
|`tmp`         |临时文件|
|`docs`        |支持文档|
|`bin`         |脚本封装|

## 端口暴露

* 80
* 443

# 快速上手

## 开发环境

```bash
$ ./lnmp-docker.sh devlopment

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.09-rc4

development

```

在 `./app` 目录下开始 PHP 项目开发。

## 生产环境

开启 `容器即服务( Caas )` 之旅。

```bash
$ ./lnmp-docker.sh production
```

生产环境镜像请按需定制，并且尽可能的拉取镜像，避免构建镜像占用时间（部署 Docker 镜像私有仓库，

## 停止

```bash
$ docker-compose stop
```

## 销毁

```bash
$ ./lnmp-docker.sh " devlopment-down | production-down "
```

# 命令行工具

为简化操作方式，本项目提供了 `交互式` 的命令行工具(`./lnmp-docker.sh`)，用法请查看 [支持文档](docs/cli.md)。

# 生产环境用户

## [khs1994.com](//khs1994.com)

## [xc725.wang](//xc725.wang)

# 更多资料

* [LNMP 容器默认配置](https://github.com/khs1994-docker/lnmp-default-config)
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)
