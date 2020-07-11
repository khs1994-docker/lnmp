# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://travis-ci.com/khs1994-docker/lnmp.svg?branch=19.03)](https://travis-ci.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=19.03)](https://ci.khs1994.com/github/khs1994-docker/lnmp)

[![star](https://gitee.com/khs1994-docker/lnmp/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/lnmp/stargazers) [![](https://img.shields.io/badge/AD-Tencent%20Kubernetes%20Engine-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

:computer: :whale: :elephant: :dolphin: :penguin: :rocket: Start LNMP In Less than 2 minutes Powered By Docker Compose, **one command** `$ ./lnmp-docker up`

| Platform | Status |
| -- | -- |
| Windows | [![Build status](https://ci.appveyor.com/api/projects/status/itgp61n808n80b8m/branch/19.03?svg=true)](https://ci.appveyor.com/project/khs1994-docker/lnmp/branch/19.03) |
| Linux |  [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=19.03)](https://ci.khs1994.com/github/khs1994-docker/lnmp) |
| macOS | [![Build Status](https://travis-ci.com/khs1994-docker/lnmp.svg?branch=19.03)](https://travis-ci.com/khs1994-docker/lnmp) |
| Linux arm64v8 | - |
| Linux arm32v7 | - |

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

* [中文说明](README.cn.md)

* [Documents](https://docs.lnmp.khs1994.com)

* [腾讯云 Kubernetes](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

* [Asciinema Live Demo](https://asciinema.org/a/215588)

* [Feedback](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ffeedback)

* [TODO](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ftodo)

* [Best Practice](https://github.com/khs1994-docker/php-demo)

* [Donate](https://zan.khs1994.com)

LNMP Docker is supported on Linux, macOS, Windows 10 on `x86_64`, and Debian (Raspberry Pi3) on `arm`.

:warning: Don't Edit Any Files except `.env` [Why ?](https://github.com/khs1994-docker/lnmp/issues/238)

:warning: Run Laravel on Docker For Windows very slow. [solve it](docs/laravel.md).

:gift: [Donate](https://zan.khs1994.com)

:whale: [腾讯云 Kubernetes](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

## WeChat

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>Welcome developer subscribe WeChat</strong></p>

## Prerequisites

To use LNMP Docker, you need:

:one: [Git](https://git-scm.com/downloads)

:two: [Docker CE](https://github.com/yeasy/docker_practice/tree/master/install) 19.03 Stable +

:three: [Docker Compose](https://github.com/yeasy/docker_practice/blob/master/compose/install.md) 1.25.0+

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

Welcome use khs1994-docker/lnmp v19.03 x86_64 With Pull Docker Image

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

:no_entry: ~~`$redis->connect('127.0.0.1',6379);`~~

:no_entry: ~~`$pdo = new \PDO('mysql:host=127.0.0.1;dbname=test;port=3306','root','mytest');`~~

```php
$redis = new \Redis();

$redis->connect('redis', 6379);

$pdo = new \PDO('mysql:host=mysql,dbname=test,port=3306', 'root', 'mytest');
```

## AD :whale:

**腾讯云 Kubernetes**

* [Tencent Kubernetes Engine](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

## Advanced

* [Kubernetes](https://github.com/khs1994-docker/lnmp-k8s)

* [Helm](https://github.com/khs1994-docker/lnmp-k8s/tree/master/helm)

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

$ ./lnmp-docker restart nginx php7
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

Please see [Documents](https://github.com/khs1994-docker/lnmp/tree/19.03/docs#%E7%89%B9%E8%89%B2).

### What's inside

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[ACME.sh](https://github.com/acmesh-official/acme.sh)                     |`khs1994/acme:2.8.6`           | **2.8.6**           |`alpine:3.12`    |
|[NGINX](https://github.com/khs1994-docker/nginx)                       |`nginx:1.19.1-alpine`          | **1.19.1**          |`alpine:3.11`    |
|[NGINX Unit](https://github.com/nginx/unit)                               |`khs1994/php:7.4.8-unit-alpine`| **1.18.0**          |`alpine:3.11`    |
|[HTTPD](https://github.com/docker-library/docs/tree/master/httpd)         |`httpd:2.4.43-alpine`          | **2.4.43**          |`alpine:3.12`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.20`                 | **8.0.20**          |`debian:buster-slim`|
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.5.4`               | **10.5.4**          |`ubuntu:bionic`  |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:6.0.5-alpine`           | **6.0.5**           |`alpine:3.12`    |
|[PHP-FPM](https://github.com/khs1994-docker/php)                          |`khs1994/php:7.4.8-fpm-alpine`     | **7.4.8**       |`alpine:3.11`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php:7.4.8-composer-alpine`| **1.10.8**      |`alpine:3.11`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.6.6-alpine`           | **1.6.6**       |`alpine:3.12`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.8.3-management-alpine` | **3.8.3**       |`alpine:3.11`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:12.3-alpine`             | **12.3**        |`alpine:3.12`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:4.2.8`                      | **4.2.8**       |`ubuntu:bionic`  |
|[PHPMyAdmin](https://github.com/phpmyadmin/docker)                        |`phpmyadmin/phpmyadmin:latest`     | **latest**      |`alpine:3.11`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`alpine:3.11`    |

### Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project (HTML, PHP, etc) |
|`backup`      |backup database file|
|`bin`         |PHPer Commands    |
|`config`      |configuration file|
|`dockerfile`  |Dockerfile        |
|`log`         |log file          |
|`scripts`     |bash shell script |

### Exposed Ports

* 80
* 443
* 8080 `PHPMyAdmin` (Development only)

## CLI

Easy to generate nginx or apache config, etc. Please use [`./lnmp-docker`](docs/cli.md).

## Run in Production

Start `Containers as a Service(CaaS)`. For more information, see [Documents](docs/swarm/README.md).

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
* [Docker Cloud](https://cloud.docker.com)
* [Tencent Cloud Container Service](https://cloud.tencent.com/product/ccs)
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

## Privacy

We send OS type and IP data to us data collection server, please set true (default) to help us improve.

You can edit `.env` file `DATA_COLLECTION=false` to disable it.

## AD :whale:

**腾讯云 Kubernetes**

* [Tencent Kubernetes Engine](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
