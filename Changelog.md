Changelog
==============

#### v17.11 rc2

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

#### v17.09 (2017-10-14)

#### v17.09 rc13

Bug fixes:
* Fix `Dockerfile`
* Fix `RabbitMQ` error

#### v17.09 rc12

Bug fixes:
* Fix `./lnmp-docker.sh` CLI

Updates:
* Update Support Documents

#### v17.09 rc11

Changes:
* Add `restart:always` in Docker Compose file
* Add `Gogs`

Updates:
* `Memcached` 1.5.2
* `nginx` 1.13.6

#### v17.09 rc10

Bug fixes:
* Fix git ssh-key CI/CD in `Production`
* Fix MySQL backup and restore

Updates:
* `PostgreSQL` 10.0

#### v17.09 rc9

Changes:
* Support `Windows 10` Powered By `Git bash`

#### v17.09 rc8

Bug fixes:
* Fix CI/CD in `Production`
* Fix `app`

Changes:
* Add `crontab` example
* Add `bash` example

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
