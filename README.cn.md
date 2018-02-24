# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp)

使用 Docker Compose 快速搭建 LNMP 环境。

* [项目初衷](docs/why.md)

* [支持文档](docs)

* [项目演示](https://asciinema.org/a/152107)

本项目支持 `x86_64` 架构的 Linux，macOS，Windows 10 并且支持 `arm` 架构的 Debian(树莓派)。

## 准备

本项目需要以下软件：

* [Docker CE](https://github.com/docker/docker-ce) 17.12 Stable +

* [Docker Compose](https://github.com/docker/compose) 1.18.0+

* WSL (**Windows** Only)

## 快速上手

简单而言，搞明白了项目路径，Nginx 配置就行了，遇到任何问题请提出 issue。

### Windows 10

如果你使用的是 Windows 10 请查看 [支持文档](docs/windows.md)。

### 安装

使用以下的任意一种方法来安装本项目。

* **使用一键安装脚本**

  ```bash
  $ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
  ```

* **使用 `git clone`**

  ```bash
  $ git clone --recursive https://github.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@github.com:khs1994-docker/lnmp.git

  # 中国镜像

  $ git clone --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
  ```

### 启动 LNMP

```bash
$ cd lnmp

$ ./lnmp-docker.sh development

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.02 x86_64 With Pull Docker Image

development

```

### PHP 项目开发

在 `./app` 目录下开始 PHP 项目开发，在 `./config/nginx/` 新建 nginx 配置文件。

你也可以使用以下命令快速的新建一个 PHP 项目，并完成后续一系列配置（生成 nginx 配置、申请 SSL 证书）。

```bash
# $ ./lnmp-docker.sh new

$ ./lnmp-docker.sh restart nginx
```

### 一键申请 SSL 证书

>由 [`acme.sh`](https://github.com/Neilpang/acme.sh) 提供支持

```bash
$ ./lnmp-docker.sh ssl www.khs1994.com
```

>一键申请证书仅支持 `dnspod.cn` DNS，使用前请提前在 `.env` 文件中设置 DNS 服务商的相关密钥。也支持一键生成自签名 SSL 证书，更多信息请查看 [支持文档](docs/nginx-with-https.md)。

### 查看详情

```bash
$ docker container ls -a -f label=com.khs1994.lnmp
```

### 自行构建 LNMP 镜像

如果要使用自行构建的镜像请查看 [支持文档](docs/development.md)

### 重启

```bash
# 全部重启
$ ./lnmp-docker.sh restart

# 重启指定软件
$ ./lnmp-docker.sh restart nginx php7
```

### 停止

```bash
$ ./lnmp-docker.sh stop
```

### 销毁

```bash
$ ./lnmp-docker.sh down
```

## 更新记录

每月更新版本，版本命名方式为 `YY.MM`，更新记录请查看 [Releases](https://github.com/khs1994-docker/lnmp/releases)。

* [v18.02 2018-02-01](https://github.com/khs1994-docker/lnmp/releases/tag/v18.02)

* ~~[v18.01 2018-01-12](https://github.com/khs1994-docker/lnmp/releases/tag/v18.01) **EOL**~~

## 支持 Kubernets

请查看 [支持文档](docs/production/k8s.md)

## 项目说明

### 支持特性

请查看 [支持文档](docs#%E6%BB%A1%E8%B6%B3-lnmp-%E5%BC%80%E5%8F%91%E5%85%A8%E9%83%A8%E9%9C%80%E6%B1%82)

### 包含软件

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

### 文件夹结构

|文件夹|说明|
|:--|:--|
|`app`         |项目文件（HTML, PHP, etc）|
|`backup`      |备份文件|
|`config`      |配置文件 「nginx 配置文件位于[Git 子模块](https://git-scm.com/book/zh/v1/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)」|               
|`dockerfile`  |自定义 Dockerfile|
|`logs`        |日志文件|
|`scripts`     |用户自定义脚本文件|

### 端口暴露

* 80
* 443

## 命令行工具

为简化操作方式，本项目提供了 `交互式` 的命令行工具 [`./lnmp-docker.sh`](docs/cli.md)

## 生产环境

马上开启 `容器即服务( CaaS )` 之旅！更多信息请查看 [支持文档](docs/production/README.md)

## LinuxKit (实验性玩法)

```bash
# OS: macOS

$ cd linuxkit

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

浏览器打开 `127.0.0.1:8080`，即可看到网页

## 生产环境用户

### [khs1994.com](//khs1994.com)

## 项目国内镜像

* TGit：https://git.qcloud.com/khs1994-docker/lnmp.git
* 阿里云 CODE：https://code.aliyun.com/khs1994-docker/lnmp.git
* 码云：https://gitee.com/khs1994/lnmp.git
* Coding：https://git.coding.net/khs1994/lnmp.git

## TLSv1.3

[原生支持 TLSv1.3](https://github.com/khs1994-website/tls-1.3).

## CI/CD

请使用 [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

## Docker Daemon TLS

请查看 [khs1994-docker/dockerd-tls](https://github.com/khs1994-docker/dockerd-tls)

## 支持文档

https://doc.lnmp.khs1994.com

## 贡献项目

请查看：[如何贡献](CONTRIBUTING.md)

## 感谢

* LNMP
* [Docker Cloud](https://cloud.docker.com)
* [Tencent Cloud Container Service](https://cloud.tencent.com/product/ccs)
* [Let's Encrypt](https://letsencrypt.org/)
* [acme.sh](https://github.com/Neilpang/acme.sh)

## 更多资料

* [LNMP 容器默认配置](https://github.com/khs1994-docker/lnmp-default-config)
* [Docker Compose 中国镜像](https://github.com/khs1994-docker/compose-cn-mirror)
* [Docker 从入门到实践](https://github.com/yeasy/docker_practice)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)
* [Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
* [micooz/docker-lnmp](https://github.com/micooz/docker-lnmp)
* [twang2218/docker-lnmp](https://github.com/twang2218/docker-lnmp)
* [bravist/lnmp-docker](https://github.com/bravist/lnmp-docker)
* [yeszao/dnmp](https://github.com/yeszao/dnmp)
* [laradock/laradock](https://github.com/laradock/laradock)

## 赞赏我

请访问 [https://zan.khs1994.com](https://zan.khs1994.com)
