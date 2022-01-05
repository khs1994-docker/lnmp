# 本地路径和 Docker 内路径对应关系

使用 Docker 新手首先可能遇到的是 `地址解析问题` 和 `路径配置问题`。

* 错误的在配置文件中或程序代码中使用 `localhost` `127.0.0.1`

* 错误的将宿主机地址写到配置文件中

## NGINX

|名称|本机|容器|
|--|--|--|
|`nginx.conf`|`./config/etc/nginx/nginx.conf`|`/etc/nginx/nginx.conf`    |
|`conf.d/`   |`./config/nginx`               |`/etc/nginx/conf.d`        |
|`error.log` |`./log/nginx/error.log`       |`/var/log/nginx/error.log` |
|`access.log`|`./log/nginx/access.log`      |`/var/log/nginx/access.log`|
|`app/`      |`./app`                        |`/app`                     |

## Apache

|名称|本机|容器|
|--|--|--|
|`httpd.conf` | `./config/etc/httpd/httpd.conf` | `/usr/local/apache2/conf/httpd.conf`|
|`conf.d/`    | `./config/httpd/`               | `/usr/local/apache2/conf.d`         |
|`logs/`      | `./log/httpd`                  | `/usr/local/apache2/logs`           |

## PHP

### php-fpm

|名称|本机|容器|
|--|--|--|
|`php.ini`                     |`./config/php/php.ini`                  |`/usr/local/etc/php/php.ini`                         |
|`docker-php.ini`   |`./config/php/docker-php.ini`        |`/usr/local/etc/php/conf.d/docker-php.ini`|
|`php-fpm.d/zz-docker.conf`    |`./config/php/zz-docker.conf`           |`/usr/local/etc/php-fpm.d/zz-docker.conf`            |
|`app/`                        |`./app`                                 |`/app`                                               |

### Composer

|名称|本机|容器|
|--|--|--|
|`缓存`|`volume:lnmp_composer-cache-data`|`/tmp/composer/cache`|

## 缓存

### Redis

|名称|本机|容器|
|--|--|--|
|`redis.conf`|`./config/redis/redis.conf`|`/usr/local/etc/redis/redis.conf`|
|`/data/`    |`redis-data`               |`/data`                          |

## 数据库

### MySQL

|名称|本机|容器|
|--|--|--|
|`docker.cnf`       |`./config/mysql/conf.d`          |`/etc/mysql/conf.d` |
|`error.log`        |`./log/mysql/error.log`          |`/var/log/mysql/error.log`     |
|`/var/lib/mysql/`  |`mysql-data`                     |`/var/lib/mysql`               |

### MariaDB

|名称|本机|容器|
|--|--|--|
|`docker.cnf`       |`./config/mysql/docker.cnf`       |`/etc/mysql/conf.d/docker.cnf` |
|`error.log`        |`./log/mysql/error.log`          |`/var/log/mysql/error.log`     |
|`/var/lib/mysql/`  |`mariadb-data`                    |`/var/lib/mysql`               |

### PostgreSQL

|名称|本机|容器|
|--|--|--|
|`/var/lib/postgresql/`|`postgresql-data`|`/var/lib/postgresql`|

### MongoDB

|名称|本机|容器|
|--|--|--|
|`/data/db/`  |`mongodb-data`                 |`/data/db/`                 |
|`mongod.conf`|`./config/mongodb/mongod.conf` |`/etc/mongod.conf`          |
|`mongo.log`  |`./log/mongodb/mongo.log`     |`/var/log/mongodb/mongo.log`|
