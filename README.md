# LNMP Docker Compose

[![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp)
[![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=dev)](https://travis-ci.org/khs1994-docker/lnmp)

务必分清`本机`路径和`容器内`路径，请仔细对照 `docker-compose.yml` 文件，或阅读 [path.md](docs/path.md)。  
提前安装配置好 [`docker-compose`](https://www.khs1994.com/docker/compose.html)

# 更新记录

每季度（17.09，17.12，18.03...）更新一个大版本，版本命名方式为（YY-MM），更新记录请查看 [Releases](https://github.com/khs1994-docker/lnmp/releases)


查看最新提交请切换到 [dev 分支](https://github.com/khs1994-docker/lnmp/tree/dev)

# 项目说明

## 包含软件

* Nginx
* MySQL
* PHP7
* Laravel
* Laravel artisan
* Composer
* Redis
* Memcached
* MongoDB
* PostgreSQL
* RabbitMQ

## 文件夹结构

|文件夹|说明|
|--|--|
|`app`         |项目文件（HTML,PHP,etc）|
|`config`      |配置文件|               
|`dockerfile`  |自定义 Dockerfile|
|`logs`        |日志文件|
|`var`         |数据文件|
|`docs`        |支持文档|
|`bin`         |脚本封装|

## 端口暴露

* 80
* 443

# Usage

* 根据实际配置修改 `.env`
* 配置 `./config/php/xdebug.ini` 中的本机IP、本机端口
* 更多用法请查看 [支持文档](https://github.com/khs1994-docker/lnmp/tree/master/docs)

## 启动

### 开发环境

```bash
$ ./docker-lnmp.sh init

$ docker-compose up -d

$ curl 127.0.0.1
Welcome use khs1994-docker/lnmp
```

### 生产环境

```bash
$ ./docker-lnmp.sh init

$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## 停止

```bash
$ docker-compose stop
```

## 销毁

```bash
$ docker-compose down
```

# CLI

# More
* [LNMP 容器默认配置](https://github.com/khs1994-docker/lnmp-default-config)
* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
