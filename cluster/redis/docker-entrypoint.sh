#!/usr/bin/env sh

set -ex

if [ "$1" = 'sh' ] || [ "$1" = 'bash' ];then
  exec sh
fi

if [ -z "${REDIS_HOST}" ];then
  exec echo "请设置 REDIS_HOST"
fi

until nc -z -w 1 ${REDIS_HOST}:7001 \
  && nc -z -w 1 ${REDIS_HOST}:7002 \
  && nc -z -w 1 ${REDIS_HOST}:7003 \
  && nc -z -w 1 ${REDIS_HOST}:8001 \
  && nc -z -w 1 ${REDIS_HOST}:8002 \
  && nc -z -w 1 ${REDIS_HOST}:8003 \
  ; do
  echo "wait"
  sleep 0.5
done

exec echo yes | redis-cli --cluster create --cluster-replicas 1 \
      ${REDIS_HOST}:7001 \
      ${REDIS_HOST}:7002 \
      ${REDIS_HOST}:7003 \
      ${REDIS_HOST}:8001 \
      ${REDIS_HOST}:8002 \
      ${REDIS_HOST}:8003
