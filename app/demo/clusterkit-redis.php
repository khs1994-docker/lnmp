<?php

// PHP 连接集群 通过集群 HOST_IP 连接，请自行替换 192.168.199.100 为实际 HOST_IP

$redisCluster=new RedisCluster(null,[
  '192.168.199.100:7001',
  '192.168.199.100:7002',
  '192.168.199.100:7003',
  '192.168.199.100:8001',
  '192.168.199.100:8002',
  '192.168.199.100:8003',
]);

// https://github.com/phpredis/phpredis/blob/feature/redis_cluster/cluster.markdown

var_dump($redisCluster);

$redisCluster->set('key', 1);
echo $redisCluster->get('key');
