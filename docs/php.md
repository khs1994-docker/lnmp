# PHP 扩展列表

> 更多扩展请通过 `$ php -m` 查看

如果你需要增加其他扩展，请到这里反馈：https://github.com/khs1994-docker/lnmp/issues/63

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
* [ ] bz2
* [ ] calendar
* [ ] com_dotnet
* [x] ctype
* [x] curl
* [x] date
* [ ] dba
* [x] dom
* [ ] enchant
* [ ] exif
* [ ] ext_skel
* [ ] ext_skel_win32.php
* [x] fileinfo
* [x] filter
* [x] ftp
* [x] gd
* [ ] gettext
* [ ] gmp
* [x] hash
* [x] iconv
* [ ] imap
* [ ] interbase
* [ ] intl
* [x] json
* [ ] ldap
* [x] libxml
* [x] mbstring
* [ ] mysqli
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
* [ ] pgsql
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
* [ ] sockets
* [x] sodium
* [x] spl
* [x] sqlite3
* [x] standard
* [ ] sysvmsg
* [ ] sysvsem
* [ ] sysvshm
* [ ] tidy
* [x] tokenizer
* [ ] wddx
* [x] xml
* [x] xmlreader
* [ ] xmlrpc
* [x] xmlwriter
* [ ] xsl
* [ ] zend_test
* [x] zip
* [x] zlib

# More Information

* [mongodb](https://github.com/mongodb/mongo-php-driver)
