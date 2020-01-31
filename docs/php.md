# PHP 扩展列表

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

> 更多扩展请通过 `$ php -m` 查看

如果你需要增加其他扩展，请到这里 [issues](https://github.com/khs1994-docker/lnmp/issues/63) 反馈。

## pecl 扩展

* [igbinary](http://pecl.php.net/package/igbinary)
* [memcached ( memcache 太旧)](https://pecl.php.net/package/memcached)
* [mongodb ( mongo 已经废弃)](https://pecl.php.net/package/mongodb)
* [redis](https://pecl.php.net/package/redis)
* [Swoole](http://pecl.php.net/package/swoole)
* [xdebug (生产环境不启用)](https://pecl.php.net/package/xdebug)
* [yaml](http://pecl.php.net/package/yaml)

## 官方扩展 (7.2.4)

```bash
$ 进入 PHP 源码目录 ext 目录

$ docker run -it -d khs1994/php-fpm:7.2.4-alpine3.7

# 记住 container id ,并替换下边命令的 CONTAINER_ID

$ for ext in `ls`; do echo '*' $( docker exec -it CONTAINER_ID php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done

$ docker rm -f CONTAINER_ID
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
* [x] ldap
* [x] libxml
* [x] mbstring
* [x] mysqli
* [x] mysqlnd
* [ ] oci8
* [ ] odbc
* [ ] opcache
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
* [x] pspell
* [x] readline
* [x] reflection
* [x] session
* [x] shmop
* [x] simplexml
* [ ] skeleton
* [ ] snmp
* [x] soap
* [x] sockets
* [x] sodium
* [x] spl
* [x] sqlite3
* [x] standard
* [x] sysvmsg
* [x] sysvsem
* [x] sysvshm
* [x] tidy
* [x] tokenizer
* [x] xml
* [x] xmlreader
* [x] xmlrpc
* [x] xmlwriter
* [x] xsl
* [ ] zend_test
* [x] zip
* [x] zlib

## Session Redis 驱动

```ini
session.save_handler = redis

session.save_path ="tcp://redis:6379?auth=redis密码
```

## More Information

* [mongodb](https://github.com/mongodb/mongo-php-driver)
