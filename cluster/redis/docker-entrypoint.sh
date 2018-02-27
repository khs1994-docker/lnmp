#!/bin/sh

if [ "$1" = 'create' ];then

if [ -z "$2" ];then
  echo "请传入 Redis Cluster HOST_IP"
  exit 1
fi

HOST_IP=$2

until nc -z -w 1 ${HOST_IP}:7002 \
  && nc -z -w 1 ${HOST_IP}:7003 \
  && nc -z -w 1 ${HOST_IP}:8001 \
  && nc -z -w 1 ${HOST_IP}:8002 \
  && nc -z -w 1 ${HOST_IP}:8003 \
  ; do
  echo "wait"
  sleep 0.5
done

exec redis-trib.rb create --replicas 1 \
      ${HOST_IP}:7001 \
      ${HOST_IP}:7002 \
      ${HOST_IP}:7003 \
      ${HOST_IP}:8001 \
      ${HOST_IP}:8002 \
      ${HOST_IP}:8003
fi

exec "$@"
