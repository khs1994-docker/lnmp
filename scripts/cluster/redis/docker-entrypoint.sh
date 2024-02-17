#!/usr/bin/env sh

set -ex

if [ "$1" = 'sh' ] || [ "$1" = 'bash' ];then
  exec sh
fi

if [ -z "${CLUSTERKIT_REDIS_NODES}" ];then
  exec echo "Please set REDIS_NODES"
fi

until `for host in ${CLUSTERKIT_REDIS_NODES};do nc -z -w 1 $host; done` ;
do
  echo "wait"
  sleep 0.5
done

redis-cli --cluster check $(echo ${CLUSTERKIT_REDIS_NODES} | cut -d ' ' -f 1) && exit 0 || true

echo yes | redis-cli --cluster create --cluster-replicas 1 ${CLUSTERKIT_REDIS_NODES}
