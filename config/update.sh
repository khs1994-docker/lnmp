#!/usr/bin/env bash

cp ~/docker/lnmp-default-config/other/redis.conf redis/

sed -i "" "s#^logfile.*#logfile /var/log/redis/redis.log#g" redis/redis.conf

sed -i "" "s/^dir.*/dir \/data/g" redis/redis.conf

cd php

rm -rf *.ini

curl -L https://raw.githubusercontent.com/php/php-src/master/php.ini-production > php-production.ini

curl -L https://raw.githubusercontent.com/php/php-src/master/php.ini-development > php-development.ini

# cp ~/docker/lnmp-default-config/other/mongod.conf mongodb/
