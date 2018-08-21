# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=master)](https://ci.khs1994.com/github/khs1994-docker/lnmp)

使用 Docker Compose 快速搭建 LNMP 环境。

More Than LNMP Docker，LNMP 全流程、全平台、全环境解决方案。

* [项目初衷](docs/why.md)

* [支持文档](docs)

* [项目演示](https://asciinema.org/a/152107)

* [反馈](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ffeedback)

* [计划支持特性](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ftodo)

* [最佳实践](https://github.com/khs1994-docker/php-demo)

本项目支持 `x86_64` 架构的 Linux，macOS，Windows 10 并且支持 `arm` 架构的 Debian(树莓派)。

**警告** 除了 `.env` 文件，本项目中的任何文件严禁二次修改。[为什么？](https://github.com/khs1994-docker/lnmp/issues/238)

**警告** Windows Docker 非常不稳定。建议使用 WSL

## 使用 k8s ?

请查看 https://github.com/khs1994-docker/lnmp-k8s

## 需要 PHP 7.1 以下版本 ?

请查看 https://github.com/khs1994-docker/lnmp/issues/354

## 使用 MySQL 8.0 遇到问题 ?

请查看 https://github.com/khs1994-docker/lnmp/issues/450

## 准备

本项目需要以下软件：

* [Docker CE](https://github.com/docker/docker-ce) 18.06 Stable +

* [Docker Compose](https://github.com/docker/compose) 1.22.0+

* WSL (**Windows** Only)

## 快速上手

简单而言，搞明白了项目路径，Nginx 配置就行了，遇到任何问题请提出 issue。

### Windows 10

如果你使用的是 Windows 10 请查看 [支持文档](docs/install/windows.md)。

#### 使用 WSL ?

请查看 https://github.com/khs1994-docker/lnmp/tree/master/wsl

### 安装

使用以下的任意一种方法来安装本项目。

* **使用 `git clone`**

  ```bash
  $ git clone --recursive https://github.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@github.com:khs1994-docker/lnmp.git

  # 中国镜像

  $ git clone --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

  # $ git clone --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
  ```

* **使用 Composer 创建项目**

  ```bash
  $ composer create-project --prefer-dist khs1994/lnmp ~/lnmp @dev
  ```

* **使用一键安装脚本**

  ```bash
  $ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
  ```

### 启动 LNMP Demo

```bash
$ cd lnmp

$ ./lnmp-docker up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.10 x86_64 With Pull Docker Image

development

```

MySQL 默认 ROOT 密码为 `mytest`

### PHP 项目开发

在 `./app` 目录下开始 PHP 项目开发，在 `./config/nginx/` 新建 nginx 配置文件。

你也可以使用以下命令快速的新建一个 PHP 项目，并完成后续一系列配置（生成 nginx 配置、申请 SSL 证书）。

```bash
# $ ./lnmp-docker new

$ ./lnmp-docker restart nginx
```

### 如何连接服务

~~`$redis->connect('127.0.0.1',6379);`~~

~~`$pdo = new \PDO('mysql:host=127.0.0.1;dbname=test;port=3306','root','mytest');`~~

```php
$redis = new \Redis();

$redis->connect('redis', 6379);

$pdo = new \PDO('mysql:host=mysql,dbname=test,port=3306', 'root', 'mytest');
```

### Docker PHP 最佳实践

* https://github.com/khs1994-docker/php-demo

### PHPer 常用命令

* `lnmp-php`

* `lnmp-composer`

* `lnmp-phpunit`

* `lnmp-laravel`

* `...`

更多信息请请查看 [支持文档](docs/command.md)

### 一键申请 SSL 证书

>由 [`acme.sh`](https://github.com/Neilpang/acme.sh) 提供支持

```bash
$ ./lnmp-docker ssl www.khs1994.com
```

>使用前请提前在 `.env` 文件或系统环境变量中设置 DNS 服务商的相关密钥。也支持一键生成自签名 SSL 证书，更多信息请查看 [支持文档](docs/issue-ssl.md)。

### 查看详情

```bash
$ docker container ls -a -f label=com.khs1994.lnmp
```

### 自行构建 LNMP 镜像

如果要使用自行构建的镜像请查看 [支持文档](docs/development.md)

### 重启

```bash
# 全部重启
$ ./lnmp-docker restart

# 重启指定软件
$ ./lnmp-docker restart nginx php7
```

### 停止

```bash
$ ./lnmp-docker stop
```

### 销毁

```bash
$ ./lnmp-docker down
```

## 更新记录

每月更新版本，版本命名方式为 `YY.MM`，更新记录请查看 [Releases](https://github.com/khs1994-docker/lnmp/releases)。

* [v18.09 2018-08-21](https://github.com/khs1994-docker/lnmp/releases/tag/v18.09)

* ~~[v18.08 2018-07-11](https://github.com/khs1994-docker/lnmp/releases/tag/v18.08) **EOL**~~

## 项目说明

### 支持特性

请查看 [支持文档](docs#%E6%BB%A1%E8%B6%B3-lnmp-%E5%BC%80%E5%8F%91%E5%85%A8%E9%83%A8%E9%9C%80%E6%B1%82)

### 包含软件

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[ACME.sh](https://github.com/Neilpang/acme.sh)                            |`khs1994/acme:2.7.9`        | **2.7.9**              |`Alpine:3.8`    |
|[NGINX](https://github.com/khs1994-website/tls-1.3)                       |`khs1994/nginx:1.15.2-alpine`| **1.15.2**             |`Alpine:3.8`    |
|[NGINX Unit](https://github.com/nginx/unit)                       |`khs1994/nginx-unit:1.3-alpine`| **1.3**             |`Alpine:3.8`    |
|[HTTPD](https://github.com/docker-library/docs/tree/master/httpd)         |`httpd:2.4.34-alpine`       | **2.4.34**             |`Alpine:3.7`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.12`              | **8.0.12**             |`Debian:stretch`|
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.3.9`            | **10.3.9**             |`Ubuntu:bionic` |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:5.0-rc4-alpine`        | **5.0-rc4**            |`Alpine:3.8`    |
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)                      |`khs1994/php:7.2.8-fpm-alpine`  | **7.2.8**       |`Alpine:3.7`    |
|[Laravel](https://github.com/laravel/laravel)                             |`khs1994/php:7.2.8-fpm-alpine`  | **5.6.x**       |`Alpine:3.7`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php:7.2.8-fpm-alpine`  | **1.7.1**       |`Alpine:3.7`    |
|[PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)              |`khs1994/php:7.2.8-fpm-alpine`  | **2.12.2**      |`Alpine:3.7`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.5.10-alpine`           | **1.5.10**       |`Alpine:3.7`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.7.6-management-alpine` | **3.7.6**       |`Alpine:3.8`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:10.4-alpine`             | **10.4**        |`Alpine:3.8`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:4.1.2`                      | **4.1.2**       |`Ubuntu:xenial` |
|[PHPMyAdmin](https://github.com/phpmyadmin/docker)                        | `phpmyadmin/phpmyadmin:latest`    | **latest**      |`Alpine:3.7`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`Alpine:3.4`    |

### 文件夹结构

|文件夹|说明|
|:--|:--|
|`app`         |项目文件（HTML, PHP, etc）|
|`backup`      |备份文件          |
|`bin`         |PHPer 常用命令    |
|`config`      |配置文件          |
|`dockerfile`  |自定义 Dockerfile |
|`logs`        |日志文件          |
|`scripts`     |用户自定义脚本文件  |

### 端口暴露

* 80
* 443
* 8080 `PHPMyAdmin` (仅开发环境)

## 命令行工具

为简化操作方式，本项目提供了 `交互式` 的命令行工具 [`./lnmp-docker`](docs/cli.md)

## 生产环境

马上开启 `容器即服务( CaaS )` 之旅！更多信息请查看 [支持文档](docs/production/README.md)

## LinuxKit (实验性玩法)

```bash
# OS: macOS

$ cd toolkit/linuxkit

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

浏览器打开 `127.0.0.1:8080`，即可看到网页

## 生产环境用户

### [khs1994.com](//khs1994.com)

### [KhsCI](https://github.com/khs1994-php/khsci)

## 项目国内镜像

* TGit：https://git.qcloud.com/khs1994-docker/lnmp.git
* 阿里云 CODE：https://code.aliyun.com/khs1994-docker/lnmp.git
* 码云：https://gitee.com/khs1994/lnmp.git
* Coding：https://git.coding.net/khs1994/lnmp.git

## TLS1.3

请查看 https://github.com/khs1994-docker/lnmp/issues/137

## CI/CD

请使用 [khs1994-docker/ci](https://github.com/khs1994-docker/ci)

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
