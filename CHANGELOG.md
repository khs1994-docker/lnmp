Changelog
==============

#### v18.03-rc2

Bug fixes:
* Fix `CLI` error #160
* Fix `php` conf error #183

Changes:
* Add `ClusterKit` include `mysql` `redis` cluster redis master-nodeX #151 #152 #156
* Add LNMP default conf #183
* Update `self build` LNMP images case #155
* Update `LinuxKit` #165
* Update run LNMP in docker for desktop `kubernetes` #172
* Update `NGINX` main conf,change log format to JSON #182
* Update `php` conf #183
* Update `httpd` conf #184
* Support `PHP-FPM` 5.6.x 7.0.x 7.1.x 7.2.x #178
* Rename `apache` to `httpd` #163
* Update CLI commands

Updates:

* `mariadb` 10.3.5 #179
* `memcached` 1.5.6 #179
* `rabbitmq` 3.7.3 #179
* `postgresql` 10.3 #179
* `mongodb` 3.7.2 #179



#### v18.03-rc1

Bug fixes:
* Fix CLI error #120 #116

Changes:
* Add CLI command `daemon-socket` #120
* Add CLI command `acme.sh` `full-up` `swarm-config` `swarm-ps` `swarm-pull` `swarm-push` `swarm-update`
* Add `docker registry` #131
* Add CLI command `registry` `registry-down` #131
* Add PHPer command exec by docker `lnmp-php` `lnmp-composer` `lnmp-phpunit` `lnmp-laravel` #143
* Update `Windows 10` case #126
* Update `macOS` case #133
* Update `Apache` #128
* Update `Dockerfile` #138 #139
* Update Production `Swarm mode` case (best-practices by khs1994.com) #141
* Update Support Documents #148
* Remove `restart:always` in development #124
* Remove khs1994 docker images #128
* Remove CLI command `composer` `laravel*` `php` `production*`
* Remove `tmp` folder
* Expose `Redis` port 6379 #116
* `NGINX` now based tlsv1.3 #136

Updates:

* `php-fpm` 7.2.2 #119
* `redis` 4.0.8 #119
* `acme.sh` 2.7.6 #123
* `nginx` 1.13.9 #134

#### [v18.01 (2018-01-12) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v18.01)

#### [v17.12 (2018-01-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.12)

#### [v17.11 (2017-12-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.11)

#### [v17.10 (2017-11-01) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.10)

#### [v17.09 (2017-10-14) EOL](https://github.com/khs1994-docker/lnmp/releases/tag/v17.09)
