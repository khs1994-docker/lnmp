#!/usr/bin/env sh

set -ex

cat /redis.conf.default > /data/redis.conf

exec docker-entrypoint.sh "$@"
