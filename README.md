# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp)

Start LNMP within 2 minutes powered by Docker Compose.

* [中文说明](README.cn.md)

* [Documents](docs/)

* [Asciinema](https://asciinema.org/a/152107)

LNMP Docker is supported on Linux, macOS, Windows 10 on `x86_64`, and Debian (Raspberry Pi3) on `arm`.

# Changelog

Updates every month, Version name is `YY-MM`. For more release information about LNMP Docker, see [Releases](https://github.com/khs1994-docker/lnmp/releases).

Latest commit in dev branch, please switch [dev](https://github.com/khs1994-docker/lnmp/tree/dev) branch.

* [v17.11 2017-12-01](https://github.com/khs1994-docker/lnmp/releases/tag/v17.11)

* ~~[v17.10 2017-11-01](https://github.com/khs1994-docker/lnmp/releases/tag/v17.10) **EOL**~~

# Prerequisites

To use LNMP Docker, you need:

* [Docker CE](https://github.com/docker/docker-ce) 17.09 Stable +

* [Docker Compose](https://github.com/docker/compose) 1.17.1+

# Quick Start

## Windows 10

Please see [Windows 10](docs/windows.md).

## Install using the convenience script

```bash
$ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
```

## Install using `git clone` in Devlopment

```bash
$ cd

$ git clone --recursive -b dev git@github.com:khs1994-docker/lnmp.git

$ cd lnmp

$ ./lnmp-docker.sh devlopment

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.11 x86_64 With Pull Docker Image

development

```

## Start PHP Project

Start PHP project(e.g, Laravel) in `./app/` folder. And edit nginx conf file `./config/nginx/yourfilename.conf`.

## Stop

```bash
$ docker-compose stop
```

## Stop and remove

```bash
$ docker-compose down
```

# Overview

## What's inside

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[NGINX](https://github.com/khs1994-docker/nginx)         |`khs1994/nginx:1.13.7-alpine`    |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/nginx.svg)](https://github.com/khs1994-docker/nginx/releases)      |`Alpine:3.5`|
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)|`mysql:5.7.20`                   |[![GitHub release](https://img.shields.io/badge/release-v5.7.20-blue.svg)](https://github.com/docker-library/docs/tree/master/mysql)       |`Debian:jessie`|
|[Redis](https://github.com/khs1994-docker/redis)         |`khs1994/redis:4.0.6-alpine`     |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/redis.svg)](https://github.com/khs1994-docker/redis/releases)      |`Alpine:3.6`|
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)     |`khs1994/php-fpm:7.2.0-alpine3.7`  |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/php-fpm.svg)](https://github.com/khs1994-docker/php-fpm/releases)  |`Alpine:3.6`|
|[Laravel](https://github.com/laravel/laravel)            |`khs1994/php-fpm:7.2.0-alpine3.7`  |[![GitHub release](https://img.shields.io/badge/release-v5.5.0-blue.svg)](https://github.com/laravel/laravel/releases)                     |`Alpine:3.6`|
|[Composer](https://github.com/docker-library/docs/tree/master/composer) |`khs1994/php-fpm:7.2.0-alpine3.7`  |[![GitHub release](https://img.shields.io/github/release/composer/composer.svg)](https://github.com/khs1994-docker/composer/composer)     |`Alpine:3.6`|
|[Memcached](https://github.com/khs1994-docker/memcached) |`khs1994/memcached:1.5.3-alpine` |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/memcached.svg)](https://github.com/khs1994-docker/memcached/releases)  |`Alpine:3.6`|
|[RabbitMQ](https://github.com/khs1994-docker/rabbitmq)   |`khs1994/rabbitmq:3.6.14-management-alpine` |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/rabbitmq.svg)](https://github.com/khs1994-docker/rabbitmq/releases)    |`Alpine:3.6`|
|[PostgreSQL](https://github.com/khs1994-docker/postgres) |`khs1994/postgres:10.1-alpine`   |[![GitHub release](https://img.shields.io/github/release/khs1994-docker/postgres.svg)](https://github.com/khs1994-docker/postgres/releases)    |`Alpine:3.6`|
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)|`mongo:3.6.0`                  |[![GitHub release](https://img.shields.io/badge/release-v3.6.0-blue.svg)](https://github.com/docker-library/docs/tree/master/mongo)       |`Debian:jessie`|

## Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project (HTML, PHP, etc) |
|`backup`      |backup database file|
|`bash`        |bash shell script|
|`config`      |configuration file|               
|`dockerfile`  |Dockerfile        |
|`logs`        |logs file         |
|`tmp`         |Composer cache file ,etc |

## Exposed Ports

* 80
* 443

# CLI

Easy to access Laravel, Laravel artisan, composer, PHP-CLI, etc. Please use [`./lnmp-docker.sh`](docs/cli.md).

# Run in Production

Start `Containers as a Service(CaaS)`. For more information, see [Documents](docs/production/README.md).

# LinuxKit

```bash
# OS: macOS

$ cd linuxkit

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

Open your Browers `127.0.0.1:8080`.

# Who use in Production?

## [khs1994.com](//khs1994.com)

# CI/CD

Please see [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

# Docker Daemon TLS

Please see [khs1994-docker/dockerd-tls](https://github.com/khs1994-docker/dockerd-tls)

# Documents

https://doc.lnmp.khs1994.com

# Contributing

Please see [Contributing](.github/CONTRIBUTING.md).

# Thanks

* [Docker Cloud](https://cloud.docker.com)
* [Tencent Cloud Container Service](https://console.cloud.tencent.com/ccs)

# More Information

* [LNMP Docker Containers default configuration file](https://github.com/khs1994-docker/lnmp-default-config)
* [docker_practice](https://github.com/yeasy/docker_practice)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)
* [bravist/lnmp-docker](https://github.com/bravist/lnmp-docker)
