# LNMP Docker

[![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=dev)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/khs1994-docker/lnmp/dev.svg)](https://github.com/khs1994-docker/lnmp/tree/dev)

Build LNMP within 2 minutes powered by Docker Compose.

* [中文说明](README.cn.md)
* [Documents](docs/)

# Changelog

Updates every quarter (17.09, 17.12, 18.03, etc), For more release information about LNMP Docker, see [Releases](https://github.com/khs1994-docker/lnmp/releases).

# Prerequisites

To use LNMP Docker,you need:

* [Docker CE](https://github.com/docker/docker-ce) 17.09.0+

* [Docker Composer](https://github.com/docker/compose) 1.16.1+

# Quick Start

Support Linux, macOS, Windows 10(Git Bash).

## Start in Devlopment

```bash
$ git clone -b dev --depth=1 git@github.com:khs1994-docker/lnmp.git

$ cd lnmp

$ ./lnmp-docker.sh devlopment

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.09 x86_64 With Pull Docker Image

development

```

Start PHP project(e.g, Laravel, ThinkPHP) in `./app/` folder.

## Run in Production

Containers as a Service(CaaS)

```bash
$ git clone -b master --depth=2 git@github.com:khs1994-docker/lnmp.git

$ cd lnmp

$ ./lnmp-docker.sh production
```

## Stop

```bash
$ docker-compose stop
```

## Stop and remove

```bash
$ docker-compose down
```

# Overview

LNMP Docker is supported on Linux, macOS, Windows 10 (PC) on `x86_64`,and Debian on `armhf`.

## What's inside

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[NGINX](https://github.com/khs1994-docker/nginx)         |khs1994/nginx:1.13.6-alpine    |`1.13.6` |Alpine:3.5|
|MySQL                                                    |mysql:5.7.19                   |`5.7.19` |Debian:jessie|
|[Redis](https://github.com/khs1994-docker/redis)         |khs1994/redis:4.0.2-alpine     |`4.0.2`  |Alpine:3.6|
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)     |khs1994/php-fpm:7.1.10-alpine  |`7.1.10` |Alpine:3.4|
|Laravel                                                  |khs1994/php-fpm:7.1.10-alpine  |`5.5`    |Alpine:3.4|
|Composer                                                 |khs1994/php-fpm:7.1.10-alpine  |`1.5.2`  |Alpine:3.4|
|[Memcached](https://github.com/khs1994-docker/memcached) |khs1994/memcached:1.5.2-alpine |`1.5.2`  |Alpine:3.6|
|[RabbitMQ](https://github.com/khs1994-docker/rabbitmq)   |khs1994/rabbitmq:3.6.12-alpine |`3.6.12` |Alpine:3.5|
|[PostgreSQL](https://github.com/khs1994-docker/postgres) |khs1994/postgres:10.0-alpine   |`10.0`   |Alpine:3.6|
|MongoDB                                                  |mongo:3.5.13                   |`3.5.13` |Debian:jessie|
|Gogs                                                     |gogs/gogs:latest               |`latest` |Alpine:3.5|

## Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project (HTML, PHP, etc) |
|`backup`      |backup database file|
|`bash`        |bash shell script|
|`ci`          |CI/CD|
|`config`      |configuration file|               
|`dockerfile`  |Dockerfile        |
|`logs`        |logs file         |
|`tmp`         |Composer cache file ,etc |

## Exposed Ports

* 80
* 443

# CLI

On Linux or macOS,Interactive `./lnmp-docker.sh` easy to access Laravel, Laravel artisan, composer, etc. For more information about LNMP Docker CLI, see [Documents](docs/cli.md).

# Who use in Production?

## [khs1994.com](//khs1994.com)

## [xc725.wang](//xc725.wang)

# More Information

* [LNMP Docker Containers default configuration file](https://github.com/khs1994-docker/lnmp-default-config)
* [docker_practice](https://github.com/yeasy/docker_practice)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)
