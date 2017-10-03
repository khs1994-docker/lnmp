Changelog
==============

#### v18.03 rc1

#### v17.12 rc1

* 生产环境 CI/CD (Git + webhooks) (Docker + webhooks)

#### v17.09 rc7

* 实验性支持 `arm64v8` 树莓派 3：树莓派使用 [Ubuntu 版本的 arm64 Docker](http://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/dists/xenial/pool/test/arm64/)
* Fix: TZ in php-fpm

#### v17.09 rc6

* `php-fpm` 基于 `Alpine Linux`
* 由于文件权限问题，`php-fpm` 使用 `root` 替代 `www-data` 用户
* `./lnmp-docker.sh` 增加架构判断（`x86_64`、`armv7l(arm32v7)`、`aarch64(arm64v8)`）来执行对应的命令
* 升级软件版本：`*` 表示该软件进行了升级

|Update|Name|Image|Version|Linux|
|:--|:--|:--|:--|:--|
||[nginx](https://github.com/khs1994-docker/nginx)         |khs1994/nginx:1.13.5-alpine    |1.13.5 |Alpine|
||MySQL                                                    |mysql:5.7.19                   |5.7.19 |Debian:jessie|
||[Redis](https://github.com/khs1994-docker/redis)         |khs1994/redis:4.0.2-alpine     |4.0.2  |Alpine|
|*|[PHP-FPM](https://github.com/khs1994-docker/php-fpm)    |khs1994/php-fpm:7.1.10-alpine  |7.1.10 |Alpine|
||[Memcached](https://github.com/khs1994-docker/memcached) |khs1994/memcached:1.5.1-alpine |1.5.1  |Alpine|
||[RabbitMQ](https://github.com/khs1994-docker/rabbitmq)   |khs1994/rabbitmq:3.6.12-alpine |3.6.12 |Alpine|
||[PostgreSQL](https://github.com/khs1994-docker/postgres) |khs1994/postgres:9.6.5-alpine  |9.6.5  |Alpine|
||MongoDB                                                  |mongo:3.5.13                   |3.5.13 |Debian:jessie|
|-|-|-|-|-|
||docker-compose                                           |-|1.16.1|-|
||docker-ce                                                |-|17.09|-|

#### v17.09 rc5

* 为加快部署速度，全部默认 `拉取` 镜像
* 使用 `数据卷`
* 增加 `MySQL` 备份、恢复功能

#### v17.09 rc4

* 由于本人水平有限，目前专注于优化已经熟练掌握的软件，其他的慢慢优化
* 实验性支持 `arm32v7` 树莓派 3
* 展望性支持 `arm64v8` 树莓派 3
* 编写支持文档
* 优化 `Dockerfile`
* Docker 镜像 TAG 锁定(在 `./.env` 文件定义)，提供一致性的环境

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

* 编写交互式命令行工具 `lnmp-docker.sh`，在 Linux、macOS 一切操作均可使用 `./lnmp-docker.sh` 完成
* 优化 `Dockerfile`，针对国内时区、网络等进行深度优化
* 增加由 `Travis CI` 支持的项目自动化测试

#### v17.09 rc2

* 增加 `生产环境` 配置
* 增加：`Composer`
* 增加：`Laravel`
* 增加：`Laravel artisan`
* 以下增加软件默认注释，请按需开启
* 增加：`MongoDB`
* 增加：`Memcached`
* 增加：`RabbitMQ`
* 增加：`PostgreSQL`

#### v17.09 rc1

* 完成 `Nginx`、`MySQL`、`Redis`、`PHP` 集成
* 改时区（基于官方 Dockerfile 重新构建镜像）
* 挂载 `项目` 文件
* 挂载 `配置` 文件
* 挂载 `日志` 文件
* 挂载 `数据` 文件
* 尽可能做到新机（提前安装配置好 Docker）一键部署 LNMP 开发环境
* 测试 PhpStorm xdebug 远程调试
