# PHP 扩展列表

* ~~mcrypt (PHP 7.2 已废弃)~~
* bcmath
* gd
* [redis](https://pecl.php.net/package/redis)
* [memcached ( memcache 太旧)](https://pecl.php.net/package/memcached)
* [mongodb ( mongo 已经废弃)](https://pecl.php.net/package/mongodb)
* [xdebug (生产环境不启用)](https://pecl.php.net/package/xdebug)
* [yaml](http://pecl.php.net/package/yaml)
* [igbinary](http://pecl.php.net/package/igbinary)
* [Swoole](http://pecl.php.net/package/swoole)
* pdo_mysql
* pdo_pgsql
* pcntl
* [zip](https://pecl.php.net/package/zip)
* opcache

> 更多扩展请通过 `$ php -m` 查看

如果你需要增加其他扩展，请到这里反馈：https://github.com/khs1994-docker/lnmp/issues/63

## 官方全部扩展 (7.2.3)

```bash
$ for ext in `ls`; do echo "* $ext"; done

$ for ext in `docker run -it --rm khs1994/php-fpm:7.2.3-alpine3.7 php -m`; do echo "* $ext";done
```

* bcmath A
* bz2 x
* calendar x
* com_dotnet x
* ctype
* curl
* date
* dba x
* dom
* enchant x
* exif x
* ext_skel x
* ext_skel_win32.php x
* fileinfo
* filter
* ftp
* gd A
* gettext x
* gmp x
* hash
* iconv
* imap x
* interbase x
* intl x
* json
* ldap x
* libxml
* mbstring
* mysqli x
* mysqlnd
* oci8 x
* odbc x
* opcache 需要自行载入
* openssl
* pcntl A
* pcre
* pdo
* pdo_dblib x
* pdo_firebird x
* pdo_mysql A
* pdo_oci x
* pdo_odbc x
* pdo_pgsql A
* pdo_sqlite
* pgsql x
* phar
* posix
* pspell x
* readline
* recode x
* reflection
* session
* shmop x
* simplexml
* skeleton x
* snmp x
* soap x
* sockets x
* sodium
* spl
* sqlite3
* standard
* sysvmsg x
* sysvsem x
* sysvshm x
* tidy x
* tokenizer
* wddx x
* xml
* xmlreader
* xmlrpc x
* xmlwriter
* xsl x
* zend_test x
* zip A
* zlib

# More Information

* [mongodb](https://github.com/mongodb/mongo-php-driver)
