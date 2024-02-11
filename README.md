# LNMP Docker

## 由于 Docker 镜像默认地址国内访问不畅，请进行如下配置

`.env` 文件增加如下内容

```bash
LNMP_DOCKER_IMAGE_PREFIX=pcit-docker.pkg.coding.net/khs1994-docker/khs1994
LNMP_LIBRARY_NS=ccr.ccs.tencentyun.com/library-mirror
```

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=20.10)](https://ci.khs1994.com/github/khs1994-docker/lnmp)

[![star](https://gitee.com/khs1994-docker/lnmp/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/lnmp/stargazers)

:computer: :whale: :elephant: :dolphin: :penguin: :rocket: Start LNMP In Less than 2 minutes Powered By Docker Compose, **one command** `$ ./lnmp-docker up`

| Platform | Status |
| -- | -- |
| Windows | [![Build status](https://ci.appveyor.com/api/projects/status/itgp61n808n80b8m/branch/20.10?svg=true)](https://ci.appveyor.com/project/khs1994-docker/lnmp/branch/20.10) |
| Linux |  [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=20.10)](https://ci.khs1994.com/github/khs1994-docker/lnmp) |
| macOS | ![CI](https://github.com/khs1994-docker/lnmp/workflows/CI/badge.svg?branch=20.10) |
| Linux arm64v8 | [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=20.10)](https://ci.khs1994.com/github/khs1994-docker/lnmp) |

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

* [中文说明](README.cn.md)

* [Documents](https://docs.lnmp.khs1994.com)

* [【腾讯云】云服务器限时秒杀，1核2G首年99元！](https://cloud.tencent.com/act/cps/redirect?redirect=1077&cps_key=3a5255852d5db99dcd5da4c72f05df61&from=console)

* [Asciinema Live Demo](https://asciinema.org/a/215588)

* [Feedback](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ffeedback)

* [TODO](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ftodo)

* [Best Practice](https://github.com/khs1994-docker/php-demo)

* [Donate](https://zan.khs1994.com)

LNMP Docker is supported on Linux, macOS, Windows 10 on `x86_64`, and Debian (Raspberry Pi3) on `arm`.

:warning: Don't Edit Any Files except `.env` [Why ?](https://github.com/khs1994-docker/lnmp/issues/238)

:warning: Run Laravel on Docker For Windows very slow. [solve it](docs/laravel.md).

:gift: [Donate](https://zan.khs1994.com)

## WeChat

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>Welcome developer subscribe WeChat</strong></p>

## Prerequisites

To use LNMP Docker, you need:

:one: [Git](https://git-scm.com/downloads)

:two: [Docker](https://github.com/yeasy/docker_practice/tree/master/install) 20.10 Stable +

:three: [Docker Compose v2.17.0+](https://github.com/yeasy/docker_practice/blob/master/compose/install.md)

:four: WSL (**Windows** Only)

## Quick Start

### Windows 10

Please see [Windows 10](docs/install/windows.md).

### Install

Use git install LNMP Docker.

```bash
$ git clone --depth=1 https://github.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --depth=1 https://gitee.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@gitee.com:khs1994-docker/lnmp.git
```

### Start LNMP Demo

```bash
$ cd lnmp

$ ./lnmp-docker up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v20.10 x86_64 With Pull Docker Image

development

```

:bulb: MySQL default root password `mytest`

### Start PHP Project

Create new folder to start PHP project(e.g, Laravel) in `./app/` folder, And edit nginx config file in `./config/nginx/yourfilename.conf`.

```bash
# $ ./lnmp-docker new

$ ./lnmp-docker restart nginx
```

> You can set `APP_ROOT` to change PHP project folder.

More information please see Docker PHP Best Practice https://github.com/khs1994-docker/php-demo

### How to connect Services

```diff
$redis = new \Redis();

- $redis->connect('127.0.0.1',6379);
+ $redis->connect('redis', 6379);

- $pdo = new \PDO('mysql:host=127.0.0.1;dbname=test;port=3306','root','mytest');
+ $pdo = new \PDO('mysql:host=mysql,dbname=test,port=3306', 'root', 'mytest');
```

## Advanced

* [Kubernetes](https://github.com/khs1994-docker/lnmp-k8s)

## PHPer commands

* `lnmp-php`

* `lnmp-composer`

* `lnmp-phpunit`

* `lnmp-laravel`

* `...`

For more information please see [Documents](docs/command.md)

## Issue SSL certificate

>Powered by [`acme.sh`](https://github.com/acmesh-official/acme.sh)

```bash
$ ./lnmp-docker ssl khs1994.com -d *.khs1994.com
```

>Please set API key and id in `.env` file or System ENV. Support Self-Signed SSL certificate, for more information, see [Documents](docs/nginx/issue-ssl.md).

## List LNMP Container

```bash
$ docker container ls -a -f label=com.khs1994.lnmp
```

## Use Self-Build Docker Image

Edit `Dockerfile` in `./dockerfile/*/Dockerfile`, then exec `./lnmp-docker build`.

## Restart

```bash
# Restart all container
$ ./lnmp-docker restart

$ ./lnmp-docker restart nginx php8
```

## Stop

```bash
$ ./lnmp-docker stop
```

## Stop and remove

```bash
$ ./lnmp-docker down
```

## Overview

### Features

Please see [Documents](https://github.com/khs1994-docker/lnmp/tree/master/docs#%E7%89%B9%E8%89%B2).

### What's inside

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[ACME.sh](https://github.com/acmesh-official/acme.sh)                     |`khs1994/acme:3.0.0`           | **3.0.0**           |`alpine:3.16`    |
|[NGINX](https://github.com/khs1994-docker/nginx)                          |`nginx:1.25.3-alpine`           | **1.25.3**          |`alpine:3.13`    |
|[NGINX Unit](https://github.com/nginx/unit)                               |`khs1994/php:8.2.13-unit-alpine`| **1.30.0**          |`alpine:3.16`    |
|[HTTPD](https://github.com/docker-library/docs/tree/master/httpd)         |`httpd:2.4.53-alpine`           | **2.4.53**          |`alpine:3.16`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.33`                  | **8.0.33**          |`oraclelinux:8-slim`|
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.11.5`                | **10.11.5**          |`ubuntu:jammy`  |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:7.0.0-alpine`            | **7.0.0**           |`alpine:3.16`    |
|[PHP-FPM](https://github.com/khs1994-docker/php)                          |`khs1994/php:8.2.13-fpm-alpine`     | **8.2.13**       |`alpine:3.19`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php:8.2.13-composer-alpine`| **2.5.8**      |`alpine:3.19`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.6.15-alpine`           | **1.6.15**       |`alpine:3.16`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.9.0-management-alpine` | **3.9.0**       |`alpine:3.13`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:14.0-alpine`             | **14.0**        |`alpine:3.14`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:5.0.3`                      | **5.0.3**       |`ubuntu:bionic`  |
|[PHPMyAdmin](https://github.com/docker-library/docs/tree/master/phpmyadmin)|`phpmyadmin:5.2.0`                | **5.2.0**       |`alpine:3.16`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`alpine:3.11`    |

### Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project (HTML, PHP, etc) |
|`scripts/backup`|backup database file|
|`bin`         |PHPer Commands    |
|`config`      |configuration file|
|`dockerfile`  |Dockerfile        |
|`log`         |log file          |
|`scripts`     |bash shell script |

### Exposed Ports

* 80
* 443

## CLI

Easy to generate nginx or apache config, etc. Please use [`./lnmp-docker`](docs/cli.md).

## Who use in Production?

### [khs1994.com](//khs1994.com)

### [PCIT -- PHP CI TOOLKIT](https://github.com/pcit-ce/pcit)

## HTTP3/QUIC

Please see https://github.com/khs1994-docker/lnmp/issues/895

## CI/CD

Please see [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

## Documents

https://docs.lnmp.khs1994.com

## Contributing

Please see [Contributing](CONTRIBUTING.md)

## Thanks

* LNMP
* [Docker Hub](https://hub.docker.com)
* [Tencent Cloud Container Service](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
* [Let's Encrypt](https://letsencrypt.org/)
* [acme.sh](https://github.com/acmesh-official/acme.sh)

## More Information

* [docker_practice](https://github.com/yeasy/docker_practice)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)
* [bravist/lnmp-docker](https://github.com/bravist/lnmp-docker)
* [yeszao/dnmp](https://github.com/yeszao/dnmp)
* [laradock/laradock](https://github.com/laradock/laradock)

## Donate

Please see [https://zan.khs1994.com](https://zan.khs1994.com)
