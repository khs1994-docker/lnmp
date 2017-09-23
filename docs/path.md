# PHP

|名称|本机|容器|
|--|--|--|
|`php.ini`                 |`./config/php/php.ini`          |`/usr/local/etc/php/php.ini`                         |
|`docker-php-ext-redis.ini`|`./config/php/conf.d/xdebug.ini`|`/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini`|
|`php-fpm.conf`            |`./config/php/php-fpm.conf`     |`/usr/local/etc/php-fpm.conf`                        |
|`php-fpm.d/`              |`./config/php/php-fpm.d`        |`/usr/local/etc/php-fpm.d`                           |
|`docker.conf`             |`./config/php/docker.conf`      |`/usr/local/etc/php-fpm.d/docker.conf`               |
|`app/`                    |`./app`                         |`/app`                                               |

# Redis

|名称|本机|容器|
|--|--|--|
|`redis.conf`|`./config/redis/redis.conf`|`/usr/local/etc/redis/redis.conf`|
|`/data/`    |`./var/lib/redis`          |`/data`                          |

# MySQL

|名称|本机|容器|
|--|--|--|
|`error.log`      |`./logs/mysql/error.log`|`/var/log/mysql/error.log`|
|`/var/lib/mysql/`|`./var/lib/mysql`      |`/var/lib/mysql`|

# Nginx

|名称|本机|容器|
|--|--|--|
|`nginx.conf`|`./config/etc/nginx/nginx.conf`|`/etc/nginx/nginx.conf`    |
|`conf.d/`   |`./config/nginx/`              |`/etc/nginx/conf.d`        |
|`error.log` |`./logs/nginx/error.log`        |`/var/log/nginx/error.log` |
|`access.log`|`./logs/nginx/access.log`       |`/var/log/nginx/access.log`|
|`app/`      |`./app`                        |`/app`                     |
