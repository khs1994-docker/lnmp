Changelog
==============

#### v18.03 rc1

#### v17.12 rc1

#### v17.09 rc11

Updates:
* `PostgreSQL` 10.0

#### v17.09 rc10

Bug fixes:
* Fix git ssh-key CI/CD in `Production`
* Fix MySQL backup and restore

#### v17.09 rc9

Changes:
* Support `Windows 10` Powered By Git bash

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
