Changelog
==============

#### v18.03 rc1

#### v17.12 rc1

#### v17.09 rc10

#### v17.09 rc5

* 常规性的升级软件

|Name|Image|Version|Linux|
|:--|:--|:--|:--|
|nginx  |khs1994/nginx:1.13.5-alpine|1.13.5 |Alpine|
|MySQL  |mysql:5.7.19               |5.7.19 |Debian:jessie|
|Redis  |khs1994/redis:4.0.2-alpine |4.0.2  |Alpine|
|php-fpm|khs1994/php-fpm:7.1.9      |7.1.9  |Debian:jessie|
|-|-|-|-|
|docker-compose|-|1.16.1|-|
|docker-ce|-|17.09|-|

#### v17.09 rc4

* 由于本人水平有限，目前专注于优化已经熟练掌握的软件，其他的慢慢优化
* 实验性支持 `arm32v7` 树莓派3
* 展望性支持 `arm64v8` 树莓派3
* 编写支持文档
* 优化 Dockerfile
* Docker Image TAG 锁定，提供一致性的环境

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

* 编写交互式命令行工具（CLI）`docker-lnmp.sh`，一切操作均可使用 CLI 完成
* 优化 Dockerfile，针对国内时区、网络等进行深度优化
* 增加由 `Travis CI` 支持的项目自动化测试

#### v17.09 rc2

* 增加 `生产环境` 配置
* 增加：Composer
* 增加：Laravel
* 增加：Laravel artisan
* 以下增加软件默认注释，请按需开启
* 增加：MongoDB
* 增加：Memcached
* 增加：RabbitMQ
* 增加：PostgreSQL

#### v17.09 rc1

* 完成 Nginx、MySQL、Redis、PHP 集成
* 改时区（基于官方 Dockerfile 重新构建镜像）
* 挂载`项目`文件
* 挂载`配置`文件
* 挂载`日志`文件
* 挂载`数据`文件
* 尽可能做到新机（提前安装配置好 Docker）一键部署 LNMP 开发环境
* 测试 PhpStorm xdebug 远程调试
