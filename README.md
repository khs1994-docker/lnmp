# LNMP Docker

[![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)]() [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=dev)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/lnmp.svg)]() [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)]()

Build LNMP within 2 minutes powered by Docker Compose.

* [中文说明](README.cn.md)
* [Documents](docs/)

# Changelog

Updates every quarter (17.09, 17.12, 18.03, etc), For more release information about LNMP Docker, see [Releases](https://github.com/khs1994-docker/lnmp/releases).

# Prerequisites

To use LNMP Docker,you need:

* Docker CE

* Docker Composer

# Quick Start

If you use Docker for Windows,see [Documents](docs/windows.md).

## Start in Devlopment

```bash
$ ./lnmp-docker.sh devlopment

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.09-rc4

development

```

Start PHP project(e.g, Laravel, ThinkPHP) in `./app/` folder.

## Run in Production

Containers as a Service(Caas)

```bash
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

## Folder Structure

|Folder|description|
|:--|:--|
|`app`         |PHP project       |
|`config`      |configuration file|               
|`dockerfile`  |Dockerfile        |
|`logs`        |logs file         |
|`var`         |databases file    |
|`tmp`         |Composer cache file ,etc |
|`docs`        |Support Documents        |
|`bin`         |bash script              |

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
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)
