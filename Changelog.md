Changelog
==============

#### v18.03 rc1

#### v17.12 rc1

#### v17.09 rc8

Bug fixes:

Changes:

* Add `crontab` example
* ADD `bash` example

Updates:

#### v17.09 rc7

Bug fixes:
* Fix TZ in php-fpm

Changes:
* Support `CI/CD` in `Production` (Git + webhooks) (Docker + webhooks)「目前仅支持本项目自动更新」
* Support `arm64v8` [Ubuntu 版本的 arm64 Docker](http://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/dists/xenial/pool/test/arm64/)

#### v17.09 rc6

Bug fixes:
* Fix `php-fpm` 使用 `root` 替代 `www-data` 用户

Changes:
* Add `php-fpm` 基于 `Alpine Linux`

Updates:
* `php-fpm` 7.1.10

|Name|Image|Version|Linux|
|:--|:--|:--|:--|
|[nginx](https://github.com/khs1994-docker/nginx)         |khs1994/nginx:1.13.5-alpine    |1.13.5 |Alpine|
|MySQL                                                    |mysql:5.7.19                   |5.7.19 |Debian:jessie|
|[Redis](https://github.com/khs1994-docker/redis)         |khs1994/redis:4.0.2-alpine     |4.0.2  |Alpine|
|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)     |khs1994/php-fpm:7.1.10-alpine  |7.1.10 |Alpine|
|[Memcached](https://github.com/khs1994-docker/memcached) |khs1994/memcached:1.5.1-alpine |1.5.1  |Alpine|
|[RabbitMQ](https://github.com/khs1994-docker/rabbitmq)   |khs1994/rabbitmq:3.6.12-alpine |3.6.12 |Alpine|
|[PostgreSQL](https://github.com/khs1994-docker/postgres) |khs1994/postgres:9.6.5-alpine  |9.6.5  |Alpine|
|MongoDB                                                  |mongo:3.5.13                   |3.5.13 |Debian:jessie|
|-|-|-|-|
|docker-compose                                           |-|1.16.1|-|
|docker-ce                                                |-|17.09|-|

#### v17.09 rc5

Changes:
* Add pull Docker Image
* Add `数据卷`
* Add `MySQL` 备份、恢复功能

#### v17.09 rc4

Bug fixes:
* Fix `Dockerfile`

Changes:
* Support `arm32v7`
* Add Documents
* Add Docker 镜像 TAG 锁定(在 `./.env` 文件定义)，提供一致性的环境

|Name|Image|Version|Linux|
|:--|:--|:--|:--|
|nginx  |khs1994/nginx:1.13.5-alpine|1.13.5 |Alpine|
|MySQL  |mysql:5.7.19               |5.7.19 |Debian:jessie|
|Redis  |khs1994/redis:4.0.2-alpine |4.0.2  |Alpine|
|php-fpm|khs1994/php-fpm:7.1.9      |7.1.9  |Debian:jessie|
|-|-|-|-|
|docker-compose|-|1.16.1|-|
|docker-ce|-|17.09|-|

#### v17.09 rc3

Bug fixes:
* Fix `Dockerfile`

Changes:
* Add `Travis CI`
* Add 交互式命令行工具 `lnmp-docker.sh`，在 Linux、macOS 一切操作均可使用 `./lnmp-docker.sh` 完成

#### v17.09 rc2

Changes:
* Support `Production`
* Add `Composer`, `Laravel`, `Laravel artisan`
* Add `MongoDB`, `Memcached`, `RabbitMQ`, `PostgreSQL`

#### v17.09 rc1

Changes:
* Add `Nginx`, `MySQL`, `Redis`, `PHP`
* Add `PhpStorm xdebug` 远程调试
