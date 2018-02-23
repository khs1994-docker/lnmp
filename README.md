# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp)

Start LNMP In Less than 2 minutes Powered By Docker Compose.

* [中文说明](README.cn.md)

* [Documents](docs/)

* [Asciinema](https://asciinema.org/a/152107)

LNMP Docker is supported on Linux, macOS, Windows 10 on `x86_64`, and Debian (Raspberry Pi3) on `arm`.

## Prerequisites

To use LNMP Docker, you need:

* [Docker CE](https://github.com/docker/docker-ce) 17.12 Stable +

* [Docker Compose](https://github.com/docker/compose) 1.18.0+

* WSL (**Windows** Only)

## Quick Start

### Windows 10

Please see [Windows 10](docs/windows.md).

### Install

Pick one method install LNMP Docker.

* **using the convenience script**

  ```bash
  $ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
  ```

* **using `git clone`**

  ```bash
  $ git clone --recursive https://github.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@github.com:khs1994-docker/lnmp.git

  # 中国镜像

  $ git clone --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
  ```

### Start

```bash
$ cd lnmp

$ ./lnmp-docker.sh development

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.02 x86_64 With Pull Docker Image

development

```

### Start PHP Project

Start PHP project(e.g, Laravel) in `./app/` folder, And edit nginx config file in `./config/nginx/yourfilename.conf`.

```bash
# $ ./lnmp-docker.sh new

$ ./lnmp-docker.sh restart nginx
```

### Issue SSL certificate

>Powered by [`acme.sh`](https://github.com/Neilpang/acme.sh)

```bash
$ ./lnmp-docker.sh ssl www.khs1994.com
```

>Only Support `dnspod.cn` DNS，Please set API key and id in `.env` file. Support Self-Signed SSL certificate, for more information, see [Documents](docs/nginx-with-https.md).

### List LNMP Container

```bash
$ docker container ls -a -f label=com.khs1994.lnmp
```

### Use Self-Build Docker Image

Edit `Dockerfile` in `./dockerfile/*/Dockerfile`, then exec `./lnmp-docker.sh build`.

### Restart

```bash
# Restart all container
$ ./lnmp-docker.sh restart

$ ./lnmp-docker.sh restart nginx php7
```

### Stop

```bash
$ ./lnmp-docker.sh stop
```

### Stop and remove

```bash
$ ./lnmp-docker.sh down
```

## Changelog

Updates every month, Version name is `YY.MM`. For more release information about LNMP Docker Version, see [Releases](https://github.com/khs1994-docker/lnmp/releases).

* [v18.02 2018-02-01](https://github.com/khs1994-docker/lnmp/releases/tag/v18.02)

* ~~[v18.01 2018-01-12](https://github.com/khs1994-docker/lnmp/releases/tag/v18.01) **EOL**~~

## Run LNMP On Kubernets

For more information please see [Documents](docs/production/k8s.md)

## Overview

### Features

Please see [Documents](docs#%E6%BB%A1%E8%B6%B3-lnmp-%E5%BC%80%E5%8F%91%E5%85%A8%E9%83%A8%E9%9C%80%E6%B1%82).

### What's inside

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[NGINX](https://github.com/khs1994-website/tls-1.3)             |`khs1994/nginx:1.13.9-tls1.3-stretch`| **1.13.9**              |`Debian:stretch`|
|[Apache](https://github.com/docker-library/docs/tree/master/httpd)        |`httpd:2.4.29-alpine`      | **2.4.29**              |`Alpine:3.6`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.3`              | **8.0.3**               |`Debian:jessie` |
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.3.4`           | **10.3.4**              |`Debian:jessie` |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:4.0.8-alpine`       | **4.0.8**               |`Alpine:3.7`    |
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)                      |`khs1994/php-fpm:7.2.2-alpine3.7`  | **7.2.2**       |`Alpine:3.7`    |
|[Laravel](https://github.com/laravel/laravel)                             |`khs1994/php-fpm:7.2.2-alpine3.7`  | **5.5**         |`Alpine:3.7`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php-fpm:7.2.2-alpine3.7`  | **1.6.3**       |`Alpine:3.7`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.5.4-alpine`           | **1.5.4**       |`Alpine:3.7`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.7.2-management-alpine` | **3.7.2**       |`Alpine:3.7`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:10.1-alpine`             | **10.1**        |`Alpine:3.6`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:3.7.1`                      | **3.7.1**       |`Debian:jessie` |
|[PHPMyAdmin](https://github.com/phpmyadmin/docker)                        | `phpmyadmin/phpmyadmin:latest`    | **latest**      |`Alpine:3.6`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`Alpine:3.4`    |

### Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project (HTML, PHP, etc) |
|`backup`      |backup database file|
|`config`      |configuration file|               
|`dockerfile`  |Dockerfile        |
|`logs`        |logs file         |
|`scripts`     |bash shell script |
|`tmp`         |Composer cache file ,etc |

### Exposed Ports

* 80
* 443

## CLI

Easy to access Laravel, Laravel artisan, composer, PHP-CLI, etc. Please use [`./lnmp-docker.sh`](docs/cli.md).

## Run in Production

Start `Containers as a Service(CaaS)`. For more information, see [Documents](docs/production/README.md).

## LinuxKit

```bash
# OS: macOS

$ cd linuxkit

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

Open your Browers `127.0.0.1:8080`

## Who use in Production?

### [khs1994.com](//khs1994.com)

## TLSv1.3

[Default Support TLSv1.3](https://github.com/khs1994-website/tls-1.3).

## CI/CD

Please see [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

## Docker Daemon TLS

Please see [khs1994-docker/dockerd-tls](https://github.com/khs1994-docker/dockerd-tls)

## Documents

https://doc.lnmp.khs1994.com

## Contributing

Please see [Contributing](CONTRIBUTING.md)

## Thanks

* LNMP
* [Docker Cloud](https://cloud.docker.com)
* [Tencent Cloud Container Service](https://cloud.tencent.com/product/ccs)
* [Let's Encrypt](https://letsencrypt.org/)
* [acme.sh](https://github.com/Neilpang/acme.sh)

## More Information

* [LNMP Docker Containers default configuration file](https://github.com/khs1994-docker/lnmp-default-config)
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
