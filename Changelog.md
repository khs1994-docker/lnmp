Changelog
==============

#### v17.11 rc13

#### v17.11 rc11 and rc12

Bug fixes:
* Fix error in `./lnmp-docker.sh`

#### v17.11 rc10

Changes:
* Add `ENV TZ=Asia/Shanghai` in `Dockerfile`

Updates:
* `PostgreSQL` 10.1

#### v17.11 rc9

Bug fixes:
* Fix error in `./lnmp-docker.sh`

#### v17.11 rc8

Updates:
* `Docker Compose` 1.17.1

#### v17.11 rc7

Changes:
* `khs1994-docker/lnmp` v17.09 End Of Life
Updates:
* `Memcached` 1.5.3
* `RabbitMQ` 3.6.14

#### v17.11 rc6

Changes:
* Support `Docker Swarm`
* Fix `Dockerfile` `docker-compose.yml`
* Remove Based Debian `php-fpm`, now based Alpine.
* Default disabled `xdebug` in `php-fpm` Dockerfile

#### v17.11 rc5

Changes:
* Add `./lnmp-docker.sh docs` Powered By GitBook

#### v17.11 rc4

Changes:
* 为尽可能加快部署，国内私有仓库(生产环境)镜像源使用 `腾讯云容器服务`

#### v17.11 rc3

Changes:
* Add LICENSE `Apache License Version 2.0`
* Add Config files

#### v17.11 rc2

Updates:
* `Docker Compose` 1.17.0
* Update Support Documents

#### v17.11 rc1

Updates:
* `Docker Compose` 1.17.0-rc1

#### v17.10 (2017-11-01)

#### v17.10 rc6

Changes:
* NOT Support `Windows 10`
Updates:
* `php-fpm` 7.1.11
* `MySQL` 5.7.20

#### v17.10 rc5

Bug fixes:
* Fix error in `./lnmp-docker.sh`

#### v17.10 rc4

Changes:
* Move `gogs` to `khs1994-docker/ci`
* Move `ci` to `khs1994-docker/ci/webhooks`

#### v17.10 rc3

Changes:
* Merge `arm32v7` `arm64v8` Compose file into one `docker-compose.arm.yml`

#### v17.10 rc2

Changes:
* Rename `.env` to `.env.example`

#### v17.10 rc1

Changes:
* Move some VARS in `docker-compose.yml` to `.env` file

Updates:
* Update Support Documents in `Production`

#### v17.09 (2017-10-14) EOL
