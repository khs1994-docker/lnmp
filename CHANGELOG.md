Changelog
==============

#### v17.12-rc10

Changes:
* Support `fish` shell completion
* Add `systemd` unit and timer demo

#### v17.12-rc9

Changes:
* Optimize `Swarm` `LinuxKit` Workflow

#### v17.12-rc8

Changes:
* 支持微信小程序 `PHP` 后端 Demo

#### v17.12-rc7

Changes:
* Add `phpMyAdmin`

* Support `Windows 10` (Not Support LCOW)

#### v17.12-rc6

Changes:
* `php-fpm` based alpine 3.7

Updates:
* `MongoDB` 3.6.0

#### v17.12-rc5

Changes:
* Add `LinuxKit`

#### v17.12-rc4

Bug fixes:  
* Fix error in `./lnmp-docker.sh`

Changes:
* Add PHP extension `opcache`

Updates:
* `php-fpm` Dockerfiles

#### v17.12-rc3

Changes:
* `./bin/install.txt` compatible `sh`
* `./lnmp-docker.sh` compatible `sh`
* Add `secrets` in `docker-compose.yml`
* Add `secrets` `configs` in `docker-stack.yml`

Updates:
* `Redis` 4.0.6

#### v17.12-rc2

Changes:
* `php-fpm` ARM64 Based alpine 3.6
* `Redis` ARM64 Based alpine 3.6

Updates:
* `composer` 1.5.5
* `Redis` 4.0.5

#### v17.12-rc1

Changes:
* `khs1994-docker/lnmp` v17.10 End Of Life

Updates:
* `php-fpm` 7.2.0
* `Redis` 4.0.4

#### v17.11 (2017-12-01)

Bug fixes:
* Fix error in `./lnmp-docker.sh`
* Fix `Dockerfile` `docker-compose.yml`

Changes:
* `khs1994-docker/lnmp` v17.09 End Of Life
* Support `Swarm mode`
* Remove Based Debian `php-fpm`, now based Alpine
* Default disabled `xdebug` in `php-fpm` Dockerfile
* Add `ENV TZ=Asia/Shanghai` in `Dockerfile`
* Add `./lnmp-docker.sh docs` Powered By GitBook
* Add LICENSE `Apache License Version 2.0`
* Add Config files
* 为尽可能加快部署，国内私有仓库(生产环境)镜像源使用 `腾讯云容器服务`

Updates:
* `php-fpm` 7.1.12
* `nginx` 1.13.7
* `PostgreSQL` 10.1
* `Memcached` 1.5.3
* `RabbitMQ` 3.6.14
* `Docker Compose` 1.17.1
* `Docker Compose` file format 3.4
* Update Support Documents

#### [v17.10 (2017-11-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.10)

#### [v17.09 (2017-10-14) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.09)
