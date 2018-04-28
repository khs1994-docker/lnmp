# PHP-FPM

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/php-fpm.svg?style=social&label=Stars)](https://github.com/khs1994-docker/php-fpm) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/php-fpm.svg)](https://github.com/khs1994-docker/php-fpm) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/php-fpm.svg)](https://store.docker.com/community/images/khs1994/php-fpm) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/php-fpm.svg)](https://store.docker.com/community/images/khs1994/php-fpm)

# Supported tags and respective `Dockerfile` links

* [`7.2.5-alpine3.7`, `alpine`, `latest` (7.2/alpine3.7/Dockerfile)](https://github.com/khs1994-docker/php-fpm/blob/7.2.5/7.2/alpine3.7/Dockerfile)

* [`7.2.5-alpine3.7` (7.2/alpine3.7/Dockerfile)](https://github.com/khs1994-docker/php-fpm/blob/7.2.5/7.2/alpine3.7/Dockerfile)

# Overview

基于官方 [PHP-FPM](https://github.com/docker-library/docs/tree/master/php) 修改的 Docker 镜像，添加了一些常用 [PHP 扩展](https://github.com/khs1994-docker/lnmp/blob/master/docs/php.md)、Composer 和 Laravel 安装程序。

# Pull

```bash
$ docker pull khs1994/php-fpm:alpine
```

# RUN

Please use `docker-compose`, example see [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp/blob/master/docker-compose.yml).

# Who use it?

[khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp) use this Docker Image.

# More Information

* [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp)

* [Official PHP Dockerfiles](https://github.com/docker-library/php)
