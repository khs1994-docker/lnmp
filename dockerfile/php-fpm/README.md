# PHP-FPM

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/php.svg?style=social&label=Stars)](https://github.com/khs1994-docker/php) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/php.svg)](https://github.com/khs1994-docker/php) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/php.svg)](https://store.docker.com/community/images/khs1994/php) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/php.svg)](https://store.docker.com/community/images/khs1994/php) [![](https://images.microbadger.com/badges/image/khs1994/php.svg)](https://microbadger.com/images/khs1994/php "Get your own image badge on microbadger.com")

* https://github.com/khs1994-docker/php

## Supported Versions

* http://php.net/supported-versions.php

## 后缀

* 7.2.13-fpm-alpine
* 7.2.13-unit-alpine
* 7.2.13-composer-alpine
* 7.2.13-supervisord-alpine

## Supported tags and respective `Dockerfile` links

* [`7.3.0-fpm-alpine`, `7.3-fpm-alpine`, `7-fpm-alpine`, `fpm-alpine`, `latest` (7.3/alpine/Dockerfile)](https://github.com/khs1994-docker/php/blob/7.3.0/7.3/alpine/Dockerfile)

* [`7.2.13-fpm-alpine`, `7.2-fpm-alpine` (7.2/alpine/Dockerfile)](https://github.com/khs1994-docker/php/blob/7.3.0/7.2/alpine/Dockerfile)

* [`7.1.25-fpm-alpine` `7.1-fpm-alpine` (7.1/alpine/Dockerfile)](https://github.com/khs1994-docker/php/blob/7.3.0/7.1/alpine/Dockerfile)

| VERSION     | DETAILS     |
| :------------- | :------------- |
| [![](https://images.microbadger.com/badges/version/khs1994/php:5.6.39-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:5.6.39-fpm-alpine "Get your own version badge on microbadger.com")       | [![](https://images.microbadger.com/badges/image/khs1994/php:5.6.39-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:5.6.39-fpm-alpine "Get your own image badge on microbadger.com")       |
| [![](https://images.microbadger.com/badges/version/khs1994/php:7.0.33-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.0.33-fpm-alpine "Get your own version badge on microbadger.com")       | [![](https://images.microbadger.com/badges/image/khs1994/php:7.0.33-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.0.33-fpm-alpine "Get your own image badge on microbadger.com")       |
| [![](https://images.microbadger.com/badges/version/khs1994/php:7.1.25-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.1.25-fpm-alpine "Get your own version badge on microbadger.com")       | [![](https://images.microbadger.com/badges/image/khs1994/php:7.1.25-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.1.25-fpm-alpine "Get your own image badge on microbadger.com")       |
| [![](https://images.microbadger.com/badges/version/khs1994/php:7.2.13-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.2.13-fpm-alpine "Get your own version badge on microbadger.com")       | [![](https://images.microbadger.com/badges/image/khs1994/php:7.2.13-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.2.13-fpm-alpine "Get your own image badge on microbadger.com")       |
| [![](https://images.microbadger.com/badges/version/khs1994/php:7.3.0-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.3.0-fpm-alpine "Get your own version badge on microbadger.com")       | [![](https://images.microbadger.com/badges/image/khs1994/php:7.3.0-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:7.3.0-fpm-alpine "Get your own image badge on microbadger.com")       |
| [![](https://images.microbadger.com/badges/version/khs1994/php:nightly-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:nightly-fpm-alpine "Get your own version badge on microbadger.com")       | [![](https://images.microbadger.com/badges/image/khs1994/php:nightly-fpm-alpine.svg)](https://microbadger.com/images/khs1994/php:nightly-fpm-alpine "Get your own image badge on microbadger.com")       |

## Overview

基于官方 [PHP](https://github.com/docker-library/docs/tree/master/php) 修改的 Docker 镜像，添加了一些常用 [PHP 扩展](https://github.com/khs1994-docker/lnmp/blob/master/docs/php.md)、Composer 和 Laravel 安装程序。

## Pull

```bash
$ docker pull khs1994/php:fpm-alpine
```

## RUN

Please use `docker-compose`, example see [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp/blob/master/docker-compose.yml).

## Who use it?

[khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp) use this Docker Image.

## Extension

```bash
$ docker-php-source extract

$ for ext in `ls /usr/src/php/ext`; do echo '*' $( php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
```

* [x] bcmath
* [x] bz2
* [x] calendar
* [ ] com_dotnet
* [x] ctype
* [x] curl
* [x] date
* [ ] dba
* [x] dom
* [x] enchant
* [x] exif
* [ ] ext_skel
* [ ] ext_skel_win32.php
* [x] fileinfo
* [x] filter
* [x] ftp
* [x] gd
* [x] gettext
* [x] gmp
* [x] hash
* [x] iconv
* [x] imap
* [ ] interbase
* [x] intl
* [x] json
* [ ] ldap
* [x] libxml
* [x] mbstring
* [x] mysqli
* [x] mysqlnd
* [ ] oci8
* [ ] odbc
* [x] opcache
* [x] openssl
* [x] pcntl
* [x] pcre
* [x] pdo
* [ ] pdo_dblib
* [ ] pdo_firebird
* [x] pdo_mysql
* [ ] pdo_oci
* [ ] pdo_odbc
* [x] pdo_pgsql
* [x] pdo_sqlite
* [x] pgsql
* [x] phar
* [x] posix
* [ ] pspell
* [x] readline
* [ ] recode
* [x] reflection
* [x] session
* [ ] shmop
* [x] simplexml
* [ ] skeleton
* [ ] snmp
* [ ] soap
* [x] sockets
* [x] sodium
* [x] spl
* [x] sqlite3
* [x] standard
* [x] sysvmsg
* [x] sysvsem
* [x] sysvshm
* [ ] tidy
* [x] tokenizer
* [ ] wddx
* [x] xml
* [x] xmlreader
* [x] xmlrpc
* [x] xmlwriter
* [x] xsl
* [ ] zend_test
* [x] zip
* [x] zlib

## More Information

* [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp)

* [Official PHP Dockerfiles](https://github.com/docker-library/php)

* https://git.alpinelinux.org/cgit/aports/tree/community/php7/APKBUILD

* https://sources.debian.org/src/php7.2/7.2.4-1/debian/control/

* https://ram.tianon.xyz/post/2017/12/26/dockerize-compiled-software.html
