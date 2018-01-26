Changelog
==============

#### v18.02-rc2

Bug fixes:
* Fix Redis config error #102
* Fix ARM nginx config error #103

Changes:
* Update Compose file format 3.5 #104
* Update Windows PowerShell script #91
* Add MySQL init scripts #90
* Add CLI command `apache-conf`, Support generate apache config file #93
* Add CLI command `tp`, Support new ThinkPHP project #93
* Add CLI command `restart`, Support safety restart container #98
* Add [test nginx configuration file] when start or restart LNMP #99
* ARM64v8 Redis Memcached RabbitMQ PostgreSQL now based Alpine #101

Updates:
* `MongoDB` 3.7.1   #96
* `MariaDB` 10.3.4  #96
* `Redis`   4.0.7   #100

#### v18.02-rc1

Bug fixes:
* Fix `php.ini` error in development #86

Changes:
* Synchronize `docker-compose` commands, Support exec original `docker-compose` commands in `./lnmp-docker.sh` #79
* Add CLI commands `k8s` `k8s-down` #82
* Move `bin` to `cli` #87
* Add donate #84
* Update `Apache2` config file #81

#### v18.01 (2018-01-12)

Bug fixes:
* Fix error in Kubernetes

Changes:
* `khs1994-docker/lnmp` v17.12 End Of Life
* Add `./lnmp-docker.sh nginx-conf` command, Support generate nginx conf
* Add `./lnmp-docker.sh ssl-self` command, Support issue Self-Signed `SSL certificate`
* Add `./lnmp-docker.sh development-pull`，Support Pull latest LNMP Docker Images in development
* Add `./lnmp-docker.sh production-pull`，Support Pull latest LNMP Docker Images in production
* Add `nginx With TLSv1.3` (Advanced, Experimental)
* Add `./lnmp-docker.sh new` command
* Add `./lnmp-docker.sh ssl` command, Support issue `SSL certificate` Powered by acme.sh
* Add `label` in compose files

Updates:
* `php-fpm` 7.2.1
* `composer` 1.6.2

#### [v17.12 (2018-01-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.12)

#### [v17.11 (2017-12-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.11)

#### [v17.10 (2017-11-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.10)

#### [v17.09 (2017-10-14) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.09)
