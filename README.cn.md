# LNMP Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![PHP from Packagist](https://img.shields.io/packagist/php-v/khs1994/lnmp.svg)](https://packagist.org/packages/khs1994/lnmp) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![Build Status](https://ci.khs1994.com/github/khs1994-docker/lnmp/status?branch=18.06)](https://ci.khs1994.com/github/khs1994-docker/lnmp)

[![star](https://gitee.com/khs1994-docker/lnmp/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/lnmp/stargazers) [![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

:computer: :whale: :elephant: :dolphin: :penguin: :rocket: 使用 Docker Compose 快速搭建 LNMP 环境。

* [项目初衷](docs/why.md)

* [支持文档](docs)

* [项目演示](https://asciinema.org/a/152107)

* [反馈](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ffeedback)

* [计划支持特性](https://github.com/khs1994-docker/lnmp/issues?q=is%3Aopen+is%3Aissue+label%3Alnmp%2Ftodo)

* [腾讯云容器服务](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

* [最佳实践](https://github.com/khs1994-docker/php-demo)

本项目支持 `x86_64` 架构的 Linux，macOS，Windows 10 并且支持 `arm` 架构的 Debian(树莓派)。

:warning: 除了 `.env` 文件，本项目中的任何文件严禁二次修改。[为什么？](https://github.com/khs1994-docker/lnmp/issues/238)

:warning: Windows Docker 非常不稳定，且运行 Laravel 相应较慢。建议使用 [WSL](wsl)。

:gift: 为了本项目的持续发展，你可以使用 [推广产品](ad) 或直接 [打赏](https://zan.khs1994.com) 赞助本项目。

## 微信订阅号

![](https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg)

关注项目作者微信订阅号，接收项目的最新动态。

## 准备

本项目需要以下软件：

:one: [Docker CE](https://github.com/docker/docker-ce) 18.06 Stable +

:two: [Docker Compose](https://github.com/docker/compose) 1.22.0+

:three: WSL (**Windows** Only)

## 快速上手

简单而言，搞明白了项目路径，NGINX 配置就行了，遇到任何问题请提出 issue。

### Windows 10

如果你使用的是 Windows 10 请查看 [支持文档](docs/install/windows.md)。

### 安装

> 鉴于国内 clone GitHub 项目较慢，本项目在 gitee.com 进行开发，每日集成到 GitHub，建议国内用户使用中国镜像

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

Welcome use khs1994-docker/lnmp v18.09 x86_64 With Pull Docker Image

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

:no_entry: ~~`$redis->connect('127.0.0.1',6379);`~~

:no_entry: ~~`$pdo = new \PDO('mysql:host=127.0.0.1;dbname=test;port=3306','root','mytest');`~~

```php
$redis = new \Redis();

$redis->connect('redis', 6379);

$pdo = new \PDO('mysql:host=mysql,dbname=test,port=3306', 'root', 'mytest');
```

## 进阶

* [Kubernetes](https://github.com/khs1994-docker/lnmp-k8s)

* [Helm](https://github.com/khs1994-docker/lnmp-k8s/tree/master/helm)

## 需要 PHP 7.1 以下版本 ?

请查看 https://github.com/khs1994-docker/lnmp/issues/354

## 使用 MySQL 8.0 遇到问题 ?

请查看 https://github.com/khs1994-docker/lnmp/issues/450

## PHPer 常用命令

* `lnmp-php`

* `lnmp-composer`

* `lnmp-phpunit`

* `lnmp-laravel`

* `...`

更多信息请请查看 [支持文档](docs/command.md)

## 一键申请 SSL 证书

>由 [`acme.sh`](https://github.com/Neilpang/acme.sh) 提供支持

```bash
$ ./lnmp-docker ssl khs1994.com -d *.khs1994.com
```

>使用前请提前在 `.env` 文件或系统环境变量中设置 DNS 服务商的相关密钥。也支持一键生成自签名 SSL 证书，更多信息请查看 [支持文档](docs/nginx/issue-ssl.md)。

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
$ ./lnmp-docker restart nginx php7
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

请查看 [支持文档](docs#%E6%BB%A1%E8%B6%B3-lnmp-%E5%BC%80%E5%8F%91%E5%85%A8%E9%83%A8%E9%9C%80%E6%B1%82)

### 包含软件

|Name|Docker Image|Version|Based|
|:-- |:--         |:--    |:--  |
|[ACME.sh](https://github.com/Neilpang/acme.sh)                            |`khs1994/acme:2.7.9`        | **2.7.9**              |`Alpine:3.8`    |
|[NGINX](https://github.com/khs1994-website/tls-1.3)                       |`khs1994/nginx:1.15.5-alpine`| **1.15.5**             |`Alpine:3.8`    |
|[NGINX Unit](https://github.com/nginx/unit)                       |`khs1994/nginx-unit:1.3-alpine`| **1.3**             |`Alpine:3.8`    |
|[HTTPD](https://github.com/docker-library/docs/tree/master/httpd)         |`httpd:2.4.35-alpine`       | **2.4.35**             |`Alpine:3.7`    |
|[MySQL](https://github.com/docker-library/docs/tree/master/mysql)         |`mysql:8.0.12`              | **8.0.12**             |`Debian:stretch`|
|[MariaDB](https://github.com/docker-library/docs/tree/master/mariadb)     |`mariadb:10.3.9`            | **10.3.9**             |`Ubuntu:bionic` |
|[Redis](https://github.com/docker-library/docs/tree/master/redis)         |`redis:5.0-rc6-alpine`        | **5.0-rc6**            |`Alpine:3.8`    |
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)                      |`khs1994/php:7.2.11-fpm-alpine`  | **7.2.11**       |`Alpine:3.8`    |
|[Laravel](https://github.com/laravel/laravel)                             |`khs1994/php:7.2.11-fpm-alpine`  | **5.7.x**       |`Alpine:3.8`    |
|[Composer](https://github.com/docker-library/docs/tree/master/composer)   |`khs1994/php:7.2.11-fpm-alpine`  | **1.7.2**       |`Alpine:3.8`    |
|[PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)              |`khs1994/php:7.2.11-fpm-alpine`  | **2.13.0**      |`Alpine:3.8`    |
|[Memcached](https://github.com/docker-library/docs/tree/master/memcached) |`memcached:1.5.11-alpine`           | **1.5.11**       |`Alpine:3.8`    |
|[RabbitMQ](https://github.com/docker-library/docs/tree/master/rabbitmq)   |`rabbitmq:3.7.8-management-alpine` | **3.7.8**       |`Alpine:3.8`    |
|[PostgreSQL](https://github.com/docker-library/docs/tree/master/postgres) |`postgres:10.4-alpine`             | **10.4**        |`Alpine:3.8`    |
|[MongoDB](https://github.com/docker-library/docs/tree/master/mongo)       |`mongo:4.1.2`                      | **4.1.2**       |`Ubuntu:xenial` |
|[PHPMyAdmin](https://github.com/phpmyadmin/docker)                        | `phpmyadmin/phpmyadmin:latest`    | **latest**      |`Alpine:3.8`    |
|[Registry](https://github.com/khs1994-docker/registry)                    |`registry:latest`                  | **latest**      |`Alpine:3.4`    |

### 文件夹结构

|文件夹|说明|
|:--|:--|
|`app`         |项目文件（HTML, PHP, etc）|
|`backup`      |备份文件          |
|`bin`         |PHPer 常用命令    |
|`config`      |配置文件          |
|`dockerfile`  |自定义 Dockerfile |
|`log`         |日志文件          |
|`scripts`     |用户自定义脚本文件  |

### 端口暴露

* 80
* 443
* 8080 `PHPMyAdmin` (仅开发环境)

## 命令行工具

为简化操作方式，本项目提供了 `交互式` 的命令行工具 [`./lnmp-docker`](docs/cli.md)

## 生产环境

马上开启 `容器即服务( CaaS )` 之旅！更多信息请查看 [支持文档](docs/swarm/README.md)

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

### [PCIT (PHP CI TOOLKIT)](https://github.com/khs1994-php/pcit)

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

## 赞助项目

请访问 [https://zan.khs1994.com](https://zan.khs1994.com)

## 数据收集

本项目每日默认会将用户的系统和 IP 信息发送到数据收集服务器。建议用户保持开启状态来帮助提升本项目。

你可以通过在 `.env` 文件中设置 `DATA_COLLECTION=false` 来禁用数据收集服务。

## 云容器服务推广 :whale:

* [腾讯云容器服务](http://dwz.cn/I2vYahwq)
