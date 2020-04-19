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

**核心扩展**

* **mcrypt** 7.2 移除
* **mysql** 7.0 移除
* **wddx** 7.4 移除

## 增加扩展

以下两种方式任选一种：

**1. 基于 `khs1994/php:X.Y.Z-TYPE-alpine` 重新构建镜像**

```docker
ARG PHP_VERSION=7.4.5

FROM khs1994/php:${PHP_VERSION}-fpm-alpine

# 扩展源码在 PHP 源码
ENV PHP_CORE_EXT \
    wddx \
    xsl

# pecl 扩展
ENV PHP_PECL_EXT \
    xxx \
    xxx2-beta \
    xxx3-x.v.z

ENV EXT_BUILD_DEP \
    xxx-dev

ENV EXT_RUN_DEP \
    xxx

RUN set -x \
    # 安装构建依赖，构建之后可以删除
    && apk add --no-cache --virtual .pecl_build_deps $EXT_BUILD_DEP $PHPIZE_DEPS \
    # 安装运行依赖，不可以删除
    && apk add --no-cache $EXT_RUN_DEP \
    # ！请自行编辑以下内容
    # 解压 PHP 源码，仅当扩展源码在 PHP 源码中时需要
    # && docker-php-source extract \
    #
    # 5.6 | 7.0
    #
    # && docker-php-ext-configure XXX --XXX \
    && docker-php-ext-install $PHP_CORE_EXT \
    && docker-php-ext-enable $PHP_CORE_EXT \
    && for extension in ${PHP_PECL_EXT};do \
         ext_real_name=$(echo ${extension} | cut -d '-' -f 1) \
         && pecl install $extension \
         && docker-php-ext-enable $ext_real_name || echo "pecl ${extension} install error" \
         && rm -rf /usr/local/lib/php/doc/$ext_real_name \
         && rm -rf /usr/local/lib/php/test/$ext_real_name \
         && rm -rf /usr/local/include/php/ext/$ext_real_name \
         && strip --strip-all $(php-config --extension-dir)/$ext_real_name.so ; \
       done \
    #
    # 7.1 + 可以使用 pickle 安装 PHP 扩展
    #
    # && echo "--xxx" > /tmp/EXT_NAME.configure.options \
    && pickle install $PHP_CORE_EXT $PHP_PECL_EXT -n --defaults --strip --cleanup \
    # ！请自行编辑以上内容
    # 清理
    && docker-php-source delete \
    && apk del --no-network .pecl_build_deps \
    && rm -rf /tmp/* \
    && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
    # 验证
    && php -m \
    && ls -la $(php-config --extension-dir)
    # ！请自行编辑以下内容
    # 默认不启用的扩展可以将配置文件改为不以 .ini 结尾的文件名
    # && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    #     /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default
```

**2. 使用 Dockerfile 重头构建**

* https://github.com/khs1994-docker/php

```bash
# 这里只列出基本参数，其他参数按需自行添加
$ docker buildx build \
  --build-arg PHP_EXTENSION_EXTRA="wddx xsl" \
  --build-arg PECL_EXTENSION_EXTRA="imagick msgpack" \
  --build-arg APK_EXTRA="libxslt" \
  --build-arg APK_DEV_EXTRA="libxslt-dev" \
  --build-arg PHP_VERSION="X.Y.Z"
  --push \
  -t USERNAME/php:X.Y.Z-TYPE-alpine FOLDER
```

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
