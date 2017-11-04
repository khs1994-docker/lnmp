# LNMP Docker

[![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=dev)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Platform](https://img.shields.io/badge/Platform-Linux%E3%80%81macOS%E3%80%81Raspberry%20Pi-blue.svg)](https://github.com/khs1994-docker/lnmp)

使用 Docker Compose 快速搭建 LNMP 环境。

* [项目初衷](docs/why.md)

* [支持文档](docs)

本项目支持 `x86_64` 架构的 Linux, macOS，并且支持 `armhf` 架构的 Debian。不再支持 Windows！

# 更新记录

每月更新版本，版本命名方式为 `YY-MM`，更新记录请查看 [Releases](https://github.com/khs1994-docker/lnmp/releases)，查看最新提交请切换到 [dev 分支](https://github.com/khs1994-docker/lnmp/tree/dev)。

最新的提交位于 [dev](https://github.com/khs1994-docker/lnmp/tree/dev) 分支。

# 准备

本项目需要以下软件：

* [Docker CE](https://github.com/docker/docker-ce) 17.10.0+

* [Docker Compose](https://github.com/docker/compose) 1.17.0+

# 快速上手

简单而言，搞明白了项目路径，Nginx 配置就行了，遇到任何问题请提出 issue。

## 使用一键安装脚本

```bash
$ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
```

## 使用 `git clone`

开发环境中，本应该在本机构建所需 Docker 镜像，但为了项目的快速启动，默认为拉取镜像，如果要构建镜像请在命令后添加 `--build`。

```bash
$ git clone --recursive -b dev --depth=1 git@github.com:khs1994-docker/lnmp.git

$ cd lnmp

$ ./lnmp-docker.sh devlopment

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.10 x86_64 With Pull Docker Image

development

```

## PHP 项目开发

在 `./app` 目录下开始 PHP 项目开发。在 `./config/nginx/` 新建 nginx 配置文件。

## 停止

```bash
$ docker-compose stop
```

## 销毁

```bash
$ docker-compose down
```

# 项目说明

## 包含软件

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[NGINX](https://github.com/khs1994-docker/nginx)         |`khs1994/nginx:1.13.6-alpine`    |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/nginx.svg)](https://github.com/khs1994-docker/nginx/releases)      |`Alpine:3.5`|
|MySQL                                                    |`mysql:5.7.20`                   |[![GitHub release](https://img.shields.io/badge/release-v5.7.20-blue.svg)](https://github.com/docker-library/docs/tree/master/mysql)       |`Debian:jessie`|
|[Redis](https://github.com/khs1994-docker/redis)         |`khs1994/redis:4.0.2-alpine`     |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/redis.svg)](https://github.com/khs1994-docker/redis/releases)      |`Alpine:3.6`|
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)     |`khs1994/php-fpm:7.1.11-alpine3.4`  |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/php-fpm.svg)](https://github.com/khs1994-docker/php-fpm/releases)  |`Alpine:3.4`|
|Laravel                                                  |`khs1994/php-fpm:7.1.11-alpine3.4`  |[![GitHub release](https://img.shields.io/badge/release-v5.5.0-blue.svg)](https://github.com/laravel/laravel/releases)                     |`Alpine:3.4`|
|Composer                                                 |`khs1994/php-fpm:7.1.11-alpine3.4`  |[![GitHub release](https://img.shields.io/badge/release-v1.5.2-blue.svg)](https://github.com/docker-library/docs/tree/master/composer)     |`Alpine:3.4`|
|[Memcached](https://github.com/khs1994-docker/memcached) |`khs1994/memcached:1.5.2-alpine` |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/memcached.svg)](https://github.com/khs1994-docker/memcached/releases)  |`Alpine:3.6`|
|[RabbitMQ](https://github.com/khs1994-docker/rabbitmq)   |`khs1994/rabbitmq:3.6.12-management-alpine` |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/rabbitmq.svg)](https://github.com/khs1994-docker/rabbitmq/releases)    |`Alpine:3.5`|
|[PostgreSQL](https://github.com/khs1994-docker/postgres) |`khs1994/postgres:10.0-alpine`   |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/postgres.svg)](https://github.com/khs1994-docker/postgres/releases)    |`Alpine:3.6`|
|MongoDB                                                  |`mongo:3.5.13`                  |[![GitHub release](https://img.shields.io/badge/release-v3.5.13-blue.svg)](https://github.com/docker-library/docs/tree/master/mongo)       |`Debian:jessie`|

## 文件夹结构

|文件夹|说明|
|:--|:--|
|`app`         |项目文件（HTML, PHP, etc）|
|`backup`      |备份文件|
|`bash`        |用户自定义脚本文件|
|`config`      |配置文件 「nginx 配置文件位于[Git 子模块](https://git-scm.com/book/zh/v1/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)」|               
|`dockerfile`  |自定义 Dockerfile|
|`logs`        |日志文件|
|`tmp`         |临时文件|

## 端口暴露

* 80
* 443

# 命令行工具

为简化操作方式，本项目提供了 `交互式` 的命令行工具 [`./lnmp-docker.sh`](docs/cli.md)。

# 生产环境

马上开启 `容器即服务( CaaS )` 之旅！更多信息请查看 [支持文档](docs/production.md)。

# 生产环境用户

## [khs1994.com](//khs1994.com)

## [xc725.wang](//xc725.wang)

# 项目国内镜像

* TGit：https://git.qcloud.com/khs1994-docker/lnmp.git
* 阿里云 CODE：https://code.aliyun.com/khs1994-docker/lnmp.git
* 码云：https://gitee.com/khs1994/lnmp.git
* Coding：https://git.coding.net/khs1994/lnmp.git

# CI/CD

请使用 [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

# 更多资料

* [LNMP 容器默认配置](https://github.com/khs1994-docker/lnmp-default-config)
* [Docker Compose 中国镜像](https://github.com/khs1994-docker/compose-cn-mirror)
* [Docker 从入门到实践](https://github.com/yeasy/docker_practice)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)

# 贡献项目

请查看：[如何贡献](CONTRIBUTING.md)

# 感谢

* [Docker Cloud](https://cloud.docker.com)
* [Tencent Cloud Container Service](https://console.cloud.tencent.com/ccs)
