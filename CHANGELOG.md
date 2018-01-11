Changelog
==============

#### v18.01-rc2

Changes:

* Add `./lnmp-docker.sh nginx-conf` command, Support generate nginx conf
* Add `./lnmp-docker.sh ssl-self` command, Support issue Self-Signed `SSL certificate`
* Add `./lnmp-docker.sh development-pull`，Support Pull latest LNMP Docker Images in development
* Add `./lnmp-docker.sh production-pull`，Support Pull latest LNMP Docker Images in production
* Add `nginx With TLSv1.3` (Advanced, Experimental)

#### v18.01-rc1

Changes:

* Add `./lnmp-docker.sh new` command
* Add `./lnmp-docker.sh ssl` command, Support issue `SSL certificate` Powered by acme.sh
* Add `label` in compose files

Updates:
* `php-fpm` 7.2.1
* `composer` 1.6.2

#### v17.12 (2018-01-01)

Bug fixes:
* Fix `composer` `laravel` `laravel-artisan` error in Production
* Fix error in `./lnmp-docker.sh`

Changes:
* `khs1994-docker/lnmp` v17.11 End Of Life
* Add `Apache` 2.4.29
* Add `MariaDB` 10.3.3
* Add `phpMyAdmin`
* Add `LinuxKit`
* Add `systemd` unit and timer demo
* Add PHP extension `opcache`
* Add `secrets` in `docker-compose.yml`
* Add `secrets` `configs` in `docker-stack.yml`
* Support `fish` `bash` shell completion
* Support `k8s`
* Support `Windows 10` (Not Support LCOW)
* Remove khs1994 build image `nginx` `memcached`
* Optimize `Swarm` `LinuxKit` Workflow
* `./bin/install.txt` `./lnmp-docker.sh` compatible `sh`
* `php-fpm` based alpine 3.7
* `php-fpm` ARM64 Based alpine 3.6
* `Redis` ARM64 Based alpine 3.6
* 支持微信小程序 `PHP` 后端 Demo

Updates:
* Update `php.ini`
* `Docker Compose` 1.18.0
* `Docker` v17.12 Stable
* `Composer` 1.5.6
* `RabbitMQ` 3.7.2
* `nginx` 1.13.8
* `MongoDB` 3.6.1
* `MySQL` 8.0.3
* `Memcached` 1.5.4
* `php-fpm` Dockerfiles
* `Composer` 1.5.5
* `Redis` 4.0.6
* `php-fpm` 7.2.0

#### [v17.11 (2017-12-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.11)

#### [v17.10 (2017-11-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.10)

#### [v17.09 (2017-10-14) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.09)
