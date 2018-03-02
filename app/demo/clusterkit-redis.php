<?php

// PHP 连接集群 通过集群 HOST_IP 连接，请自行替换 192.168.199.100 为实际 HOST_IP

const REDIS_CLUSTER_HOST = '192.168.199.100';

$redisCluster=new RedisCluster(null, [
  REDIS_CLUSTER_HOST.':7001',
  REDIS_CLUSTER_HOST.':7002',
  REDIS_CLUSTER_HOST.':7003',
  REDIS_CLUSTER_HOST.':8001',
  REDIS_CLUSTER_HOST.':8002',
  REDIS_CLUSTER_HOST.':8003',
]);

// https://github.com/phpredis/phpredis/blob/feature/redis_cluster/cluster.markdown

var_dump($redisCluster);

$redisCluster->set('key', 1);
echo $redisCluster->get('key');
