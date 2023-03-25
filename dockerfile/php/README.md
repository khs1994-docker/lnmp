# PHP-FPM

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/php.svg?style=social&label=Stars)](https://github.com/khs1994-docker/php) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/php.svg)](https://github.com/khs1994-docker/php) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/php.svg)](https://hub.docker.com/r/khs1994/php) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/php.svg)](https://hub.docker.com/r/khs1994/php) [![Build Status](https://dev.azure.com/khs1994-docker/php/_apis/build/status/khs1994-docker.php?branchName=master)](https://dev.azure.com/khs1994-docker/php/_build/latest?definitionId=1&branchName=master)

* https://github.com/khs1994-docker/php

## Supported Versions

* https://www.php.net/supported-versions.php

## 中国镜像 [![中国镜像同步状态](https://pcit.coding.net/badges/khs1994-docker/job/234051/build.svg)](https://pcit.coding.net/p/khs1994-docker/ci/job)

[ccr.ccs.tencentyun.com/khs1994/php:TAG](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

## 后缀

* 8.2.2-cli-alpine
* 8.2.2-fpm-alpine
* 8.2.2-unit-alpine         (based cli)
* 8.2.2-composer-alpine     (based fpm)
* 8.2.2-swoole-alpine       (based cli)
* 8.2.2-s6-alpine           (based fpm)

## Supported tags and respective `Dockerfile` links

* [`8.2.2-fpm-alpine` (8.2/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/8.2.2/8.2/fpm/Dockerfile)

* [`8.1.11-fpm-alpine` (8.1/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/8.2.2/8.1/fpm/Dockerfile)

* [`8.0.25-fpm-alpine` (8.0/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/8.2.2/8.0/fpm/Dockerfile)

* [`nightly-fpm-alpine` (nightly/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/master/nightly/fpm/Dockerfile)

* [`7.4.33-fpm-alpine` (7.4/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/8.2.2/7.4/fpm/Dockerfile)

* [`7.3.33-fpm-alpine` (7.3/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/8.2.2/7.3/fpm/Dockerfile)

* [`7.2.34-fpm-alpine` (7.2/fpm/Dockerfile)](https://github.com/khs1994-docker/php/blob/8.2.2/7.2/fpm/Dockerfile)

## Overview

基于官方 [PHP](https://github.com/docker-library/docs/tree/master/php) 修改的 Docker 镜像，添加了一些常用 [PHP 扩展](https://github.com/khs1994-docker/lnmp/blob/master/docs/php.md)、Composer 和 Laravel 安装程序。

## RUN

Please use `docker-compose`, example see [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp/blob/master/docker-lnmp.yml).

## Who use it?

[khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp) use this Docker Image.

## bin

* php
* php-cgi
* php-config
* phpdbg
* phpize

## sbin

* php-fpm

## Extension

[pickle](https://github.com/khs1994-php/pickle)

```bash
$ pickle install x x1 x2-beta x3-x.y.z -n --defaults
```

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
* [ ] ext_skel.php
* [x] ffi
* [x] fileinfo
* [x] filter
* [x] ftp
* [x] gd
* [x] gettext
* [x] gmp
* [x] hash
* [x] iconv
* [x] imap
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
* [x] reflection
* [x] session
* [x] shmop
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
* [x] xml
* [x] xmlreader
* [x] xmlwriter
* [ ] xsl
* [ ] zend_test
* [x] zip
* [x] zlib

## 系统支持

### Debian Buster 不支持 7.3 及以下（freetype-config）

* https://salsa.debian.org/php-team/php/-/blob/debian/7.3.9-1/debian/patches/0047-Use-pkg-config-for-FreeType2-detection.patch

* https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=870618

## More Information

* [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp)

* [Official PHP Dockerfiles](https://github.com/docker-library/php)

* https://git.alpinelinux.org/aports/tree/community/php8/APKBUILD

* https://sources.debian.org/src/php7.3/7.3.29-1~deb10u1/debian/control/

* https://sources.debian.org/src/php7.4/7.4.33-1+deb11u1/debian/control/

* https://sources.debian.org/src/php8.1/8.2.2-1/debian/control/

* https://ram.tianon.xyz/post/2017/12/26/dockerize-compiled-software.html

* https://www.docker.com/blog/multi-arch-images/

* https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
