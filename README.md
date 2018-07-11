# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=master)](https://ci.khs1994.com/github/khs1994-docker/lnmp)

Start LNMP In Less than 2 minutes Powered By Docker Compose.

More Than LNMP Docker，Support ALL Arch、ALL Environment.

* [中文说明](README.cn.md)

* [Documents](docs/)

* [Asciinema](https://asciinema.org/a/152107)

* [Feedback](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ffeedback)

* [TODO](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ftodo)

* [Best Practice](https://github.com/khs1994-docker/php-demo)

LNMP Docker is supported on Linux, macOS, Windows 10 on `x86_64`, and Debian (Raspberry Pi3) on `arm`.

**Warning** Don't Edit Any Files except `.env`， [Why ?](https://github.com/khs1994-docker/lnmp/issues/238)

## Try k8s ?

Please see https://github.com/khs1994-docker/lnmp-k8s

## Need PHP Under 7.1?

Please see https://github.com/khs1994-docker/lnmp/issues/354

## Meet issues With MySQL 8.0 ?

Please see https://github.com/khs1994-docker/lnmp/issues/450

## Prerequisites

To use LNMP Docker, you need:

* [Docker CE](https://github.com/docker/docker-ce) 18.03 Stable +

* [Docker Compose](https://github.com/docker/compose) 1.20.1+

* WSL (**Windows** Only)

## Quick Start

### Windows 10

Please see [Windows 10](docs/install/windows.md).

#### Try WSL ?

Please see https://github.com/khs1994-docker/lnmp/tree/master/wsl

### Install

Pick one method install LNMP Docker.

* **Using `git clone`**

  ```bash
  $ git clone --recursive https://github.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@github.com:khs1994-docker/lnmp.git

  # 中国镜像

  $ git clone --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
  ```

* **Using Composer create project**

  ```bash
  $ composer create-project --prefer-dist khs1994/lnmp ~/lnmp @dev
  ```

* **Using dpkg in Debian**

  ```bash
  $ wget https://github.com/khs1994-docker/lnmp/releases/download/v18.05/khs1994-docker-lnmp_18.05_amd64.deb

  $ sudo dpkg -i khs1994-docker-lnmp*.deb
  ```

* **Using rpm in RHEL**

   ```bash
   $ wget https://github.com/khs1994-docker/lnmp/releases/download/v18.05/khs1994-docker-lnmp-18.05-1.el7.centos.x86_64.rpm

   $ sudo yum install khs1994-docker-lnmp*.rpm [-y]
   ```

* **Using the convenience script**

  ```bash
  $ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
  ```

### Start LNMP Demo

```bash
$ cd lnmp

$ ./lnmp-docker.sh up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.08 x86_64 With Pull Docker Image

development

```

MySQL default root password `mytest`

### Start PHP Project

Start PHP project(e.g, Laravel) in `./app/` folder, And edit nginx config file in `./config/nginx/yourfilename.conf`.

```bash
# $ ./lnmp-docker.sh new

$ ./lnmp-docker.sh restart nginx
```

### How to connect Services

~~`$redis->connect('127.0.0.1',6379);`~~

~~`$pdo = new \PDO('mysql:host=127.0.0.1;dbname=test;port=3306','root','mytest');`~~

```php
$redis = new \Redis();

$redis->connect('redis', 6379);

$pdo = new \PDO('mysql:host=mysql,dbname=test,port=3306', 'root', 'mytest');
```

### Docker PHP Best Practice

* https://github.com/khs1994-docker/php-demo

### PHPer commands

* `lnmp-php`

* `lnmp-composer`

* `lnmp-phpunit`

* `lnmp-laravel`

* `...`

For more information please see [Documents](docs/command.md)

### Issue SSL certificate

>Powered by [`acme.sh`](https://github.com/Neilpang/acme.sh)

```bash
$ ./lnmp-docker.sh ssl www.khs1994.com
```

>Please set API key and id in `.env` file or System ENV. Support Self-Signed SSL certificate, for more information, see [Documents](docs/issue-ssl.md).

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

* [v18.07 2018-05-20](https://github.com/khs1994-docker/lnmp/releases/tag/v18.07)

* ~~[v18.06 2018-04-28](https://github.com/khs1994-docker/lnmp/releases/tag/v18.06) **EOL**~~

## Overview

### Features

Please see [Documents](docs#%E6%BB%A1%E8%B6%B3-lnmp-%E5%BC%80%E5%8F%91%E5%85%A8%E9%83%A8%E9%9C%80%E6%B1%82).

### What's inside

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[ACME.sh](https://github.com/Neilpang/acme.sh)                            |`khs1994/acme:2.7.8`        | **2.7.8**              |`Alpine:3.7`    |
|[NGINX](https://github.com/khs1994-website/tls-1.3)                       |`khs1994/nginx:1.15.1-alpine`| **1.15.1**             |`Alpine:3.7`    |
|[HTTPD](https://github.com/docker-library/docs/tree/master/httpd)         |`httpd:2.4.33-alpine`       | **2.4.33**             |`Alpine:3.7`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.11`              | **8.0.11**             |`Debian:stretch`|
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.3.7`            | **10.3.7**             |`Debian:jessie` |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:5.0-rc3-alpine`        | **5.0-rc3**            |`Alpine:3.8`    |
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)                      |`khs1994/php-fpm:7.2.7-alpine3.7`  | **7.2.7**       |`Alpine:3.7`    |
|[Laravel](https://github.com/laravel/laravel)                             |`khs1994/php-fpm:7.2.7-alpine3.7`  | **5.6.x**       |`Alpine:3.7`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php-fpm:7.2.7-alpine3.7`  | **1.6.5**       |`Alpine:3.7`    |
|[PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)              |`khs1994/php-fpm:7.2.7-alpine3.7`  | **2.12.1**      |`Alpine:3.7`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.5.9-alpine`           | **1.5.9**       |`Alpine:3.7`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.7.6-management-alpine` | **3.7.6**       |`Alpine:3.7`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:10.4-alpine`             | **10.4**        |`Alpine:3.8`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:4.0.0`                      | **4.0.0**       |`Ubuntu:xenial` |
|[PHPMyAdmin](https://github.com/phpmyadmin/docker)                        | `phpmyadmin/phpmyadmin:latest`    | **latest**      |`Alpine:3.7`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`Alpine:3.4`    |

### Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project (HTML, PHP, etc) |
|`backup`      |backup database file|
|`bin`         |PHPer Commands    |
|`config`      |configuration file|               
|`dockerfile`  |Dockerfile        |
|`logs`        |logs file         |
|`scripts`     |bash shell script |

### Exposed Ports

* 80
* 443
* 8080 `PHPMyAdmin` (Development only)

## CLI

Easy to generate nginx or apache config, etc. Please use [`./lnmp-docker.sh`](docs/cli.md).

## Run in Production

Start `Containers as a Service(CaaS)`. For more information, see [Documents](docs/production/README.md).

## LinuxKit

```bash
# OS: macOS

$ cd toolkit/linuxkit

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

Open your Browers `127.0.0.1:8080`

## Who use in Production?

### [khs1994.com](//khs1994.com)

### [KhsCI](https://github.com/khs1994-php/khsci)

## TLS1.3

Please see https://github.com/khs1994-docker/lnmp/issues/137

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
