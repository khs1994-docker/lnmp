# LNMP Docker

[![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)]() [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=dev)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/lnmp.svg)]() [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)]()

使用 Docker Compose 快速搭建 LNMP 环境。

* [项目初衷](/docs/why.md)

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
