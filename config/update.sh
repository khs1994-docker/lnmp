#!/usr/bin/env bash

cp ~/docker/lnmp-default-config/other/redis.conf redis/

sed -i "" "s#^logfile.*#logfile /var/log/redis/redis.log#g" redis/redis.conf

sed -i "" "s/^dir.*/dir \/data/g" redis/redis.conf

# cp ~/docker/lnmp-default-config/other/mongod.conf mongodb/
