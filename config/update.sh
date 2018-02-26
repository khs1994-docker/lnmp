#!/usr/bin/env bash

. ../.env

wget https://gitee.com/mirrors/redis/raw/${KHS1994_LNMP_REDIS_VERSION}/redis.conf -O redis/redis.conf

cp redis/redis.conf redis/redis.production.conf

curl -L https://raw.githubusercontent.com/php/php-src/php-${KHS1994_LNMP_PHP_VERSION}/php.ini-production > php/php.production.ini

curl -L https://raw.githubusercontent.com/php/php-src/php-${KHS1994_LNMP_PHP_VERSION}/php.ini-development > php/php.development.ini
