#!/bin/sh

cat /redis.conf.default > /data/redis.conf

exec docker-entrypoint.sh "$@"
