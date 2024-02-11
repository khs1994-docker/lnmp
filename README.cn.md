# LNMP Docker

## 由于 Docker 镜像默认地址国内访问不畅，请进行如下配置

`.env` 文件增加如下内容

```bash
LNMP_DOCKER_IMAGE_PREFIX=pcit-docker.pkg.coding.net/khs1994-docker/khs1994
LNMP_LIBRARY_NS=ccr.ccs.tencentyun.com/library-mirror
```

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=20.10)](https://ci.khs1994.com/github/khs1994-docker/lnmp)

[![star](https://gitee.com/khs1994-docker/lnmp/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/lnmp/stargazers)

:computer: :whale: :elephant: :dolphin: :penguin: :rocket: 使用 Docker Compose 快速搭建 LNMP 环境，仅需 **一条命令** `$ ./lnmp-docker up`

**企业版** 个性化定制请访问 [`lnmp-ee`](https://github.com/khs1994-docker/lnmp-ee)

| Platform | Status |
| -- | -- |
| Windows | [![Build status](https://ci.appveyor.com/api/projects/status/itgp61n808n80b8m/branch/20.10?svg=true)](https://ci.appveyor.com/project/khs1994-docker/lnmp/branch/20.10) |
| Linux |  [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=20.10)](https://ci.khs1994.com/github/khs1994-docker/lnmp) |
| macOS | ![CI](https://github.com/khs1994-docker/lnmp/workflows/CI/badge.svg?branch=20.10) |
| Linux arm64v8 | - |

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

* [项目初衷](docs/why.md)

* [支持文档](https://docs.lnmp.khs1994.com)

* [【腾讯云】云服务器限时秒杀，1核2G首年99元！](https://cloud.tencent.com/act/cps/redirect?redirect=1077&cps_key=3a5255852d5db99dcd5da4c72f05df61&from=console)

* [项目演示](https://asciinema.org/a/215588)

* [反馈](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ffeedback)

* [计划支持特性](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ftodo)

* [最佳实践](https://github.com/khs1994-docker/php-demo)

* [赞助](https://zan.khs1994.com)

本项目支持 `x86_64` 架构的 Linux，macOS，Windows 10 并且支持 `arm` 架构的 Debian(树莓派)。

:warning: 除了 `.env` 等特定文件，本项目中的任何文件严禁二次修改。[为什么？](https://github.com/khs1994-docker/lnmp/issues/238)

:warning: Windows Docker 非常不稳定，且运行 Laravel 响应较慢。[解决办法](docs/laravel.md)

:gift: 为了本项目的持续发展，你可以使用 [推广产品](ad) 或直接 [打赏](https://zan.khs1994.com) 赞助本项目。

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## 准备

本项目需要以下软件：

:one: [Git](https://mirrors.huaweicloud.com/git-for-windows/)

:two: [Docker](https://github.com/yeasy/docker_practice/tree/master/install) 20.10 Stable +

:three: [Docker Compose v2.17.0+](https://github.com/yeasy/docker_practice/blob/master/compose/install.md)

:four: WSL (**Windows** Only)

## 快速上手

### Windows 10

如果你使用的是 Windows 10 请查看 [支持文档](docs/install/windows.md)。

### 安装

> 鉴于国内 clone GitHub 项目较慢，本项目在 gitee.com 托管，每日集成到 GitHub，建议国内用户使用中国镜像，技术交流请到本项目 GitHub，避免在 gitee.com 提 issue 或 PR。

```bash
$ git clone --depth=1 https://github.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@github.com:khs1994-docker/lnmp.git

# 从 GitHub 克隆太慢？请使用中国镜像

$ git clone --depth=1 https://gitee.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@gitee.com:khs1994-docker/lnmp.git
```

### 启动 LNMP Demo

```bash
$ cd lnmp

$ ./lnmp-docker up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v20.10 x86_64 With Pull Docker Image

development

```

:bulb: MySQL 默认 ROOT 密码为 `mytest`

### PHP 项目开发

在 `./app/` 下新建一个文件夹作为 PHP 项目开发目录，并在 `./config/nginx/` 新建一个 nginx 配置文件。

你也可以使用以下命令快速的新建一个 PHP 项目，并完成后续一系列配置（生成 nginx 配置、申请 SSL 证书）。

```bash
# $ ./lnmp-docker new

$ ./lnmp-docker restart nginx
```

> 你可以通过设置 `APP_ROOT` 来改变 PHP 项目文件夹所在位置。

更多信息请查看 LNMP 容器化最佳实践 https://github.com/khs1994-docker/php-demo

### 如何连接服务

```diff
$redis = new \Redis();

- $redis->connect('127.0.0.1',6379);
+ $redis->connect('redis', 6379);

- $pdo = new \PDO('mysql:host=127.0.0.1;dbname=test;port=3306','root','mytest');
+ $pdo = new \PDO('mysql:host=mysql,dbname=test,port=3306', 'root', 'mytest');
```

## 进阶

* [Kubernetes](https://github.com/khs1994-docker/lnmp-k8s)

## PHPer 常用命令

* `lnmp-php`

* `lnmp-composer`

* `lnmp-phpunit`

* `lnmp-laravel`

* `...`

更多信息请请查看 [支持文档](docs/command.md)

## 一键申请 SSL 证书

>由 [`acme.sh`](https://github.com/acmesh-official/acme.sh) 提供支持

```bash
$ ./lnmp-docker ssl khs1994.com -d *.khs1994.com
```

>使用前请提前在 `.env` 文件或系统环境变量中设置 DNS 服务商的相关密钥。也支持一键生成自签名 SSL 证书，更多信息请查看 [支持文档](docs/nginx/issue-ssl.md)

## 查看详情

```bash
$ docker container ls -a -f label=com.khs1994.lnmp
```

## 自行构建 LNMP 镜像

如果要使用自行构建的镜像请查看 [支持文档](docs/development.md)

## 重启

```bash
# 全部重启
$ ./lnmp-docker restart

# 重启指定软件
$ ./lnmp-docker restart nginx php8
```

## 停止

```bash
$ ./lnmp-docker stop
```

## 销毁

```bash
$ ./lnmp-docker down
```

## 项目说明

### 支持特性

请查看 [支持文档](https://github.com/khs1994-docker/lnmp/tree/master/docs#%E7%89%B9%E8%89%B2)

### 包含软件

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[ACME.sh](https://github.com/acmesh-official/acme.sh)                     |`khs1994/acme:3.0.0`            | **3.0.0**           |`alpine:3.16`    |
|[NGINX](https://github.com/khs1994-docker/nginx)                          |`nginx:1.25.3-alpine`           | **1.25.3**          |`alpine:3.13`    |
|[NGINX Unit](https://github.com/nginx/unit)                               |`khs1994/php:8.2.13-unit-alpine`| **1.30.0**          |`alpine:3.16`    |
|[HTTPD](https://github.com/docker-library/docs/tree/master/httpd)         |`httpd:2.4.53-alpine`           | **2.4.53**          |`alpine:3.16`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.33`                  | **8.0.33**          |`oraclelinux:8-slim`|
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.11.5`                | **10.11.5**          |`ubuntu:jammy`  |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:7.0.0-alpine`            | **7.0.0**           |`alpine:3.16`    |
|[PHP-FPM](https://github.com/khs1994-docker/php)                          |`khs1994/php:8.2.13-fpm-alpine`     | **8.2.13**      |`alpine:3.19`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php:8.2.13-composer-alpine`| **2.5.8**     |`alpine:3.19`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.6.15-alpine`           | **1.6.15**       |`alpine:3.16`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.9.0-management-alpine` | **3.9.0**       |`alpine:3.13`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:14.0-alpine`             | **14.0**        |`alpine:3.14`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:5.0.3`                      | **5.0.3**       |`ubuntu:bionic`  |
|[PHPMyAdmin](https://github.com/docker-library/docs/tree/master/phpmyadmin)|`phpmyadmin:5.2.0`                | **5.2.0**       |`alpine:3.16`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`alpine:3.11`    |

### 文件夹结构

|文件夹|说明|
|:--|:--|
|`app`         |项目文件（HTML, PHP, etc）|
|`scripts/backup` |备份文件       |
|`bin`         |PHPer 常用命令    |
|`config`      |配置文件          |
|`dockerfile`  |自定义 Dockerfile |
|`log`         |日志文件          |
|`scripts`     |用户自定义脚本文件 |

### 端口暴露

* 80
* 443

## 命令行工具

为简化操作方式，本项目提供了 `交互式` 的命令行工具 [`./lnmp-docker`](docs/cli.md)

## 生产环境用户

### [khs1994.com](//khs1994.com)

### [PCIT -- PHP CI TOOLKIT](https://github.com/pcit-ce/pcit)

## 项目国内镜像

* 码云：https://gitee.com/khs1994-docker/lnmp.git

## HTTP3/QUIC

请查看 https://github.com/khs1994-docker/lnmp/issues/895

## CI/CD

请使用 [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

## 支持文档

https://docs.lnmp.khs1994.com

## 贡献项目

请查看：[如何贡献](CONTRIBUTING.md)

## 感谢

* LNMP
* [Docker Hub](https://hub.docker.com)
* [Tencent Cloud Container Service](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
* [Let's Encrypt](https://letsencrypt.org/)
* [acme.sh](https://github.com/acmesh-official/acme.sh)

## 更多资料

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

## 赞助项目

请访问 [https://zan.khs1994.com](https://zan.khs1994.com)
