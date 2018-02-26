<?php

// $redisCluster=new RedisCluster(null,[
//   '172.16.0.101:6379',
//   '172.16.0.102:7002',
//   '172.16.0.103:7003',
//   '172.16.0.201:8001',
//   '172.16.0.202:8002',
//   '172.16.0.203:8003',
// ]);

// https://github.com/phpredis/phpredis/blob/feature/redis_cluster/cluster.markdown

$redisCluster=new RedisCluster(null,[
  'redis_master-1:6379',
  'redis_master-2:7002',
  'redis_master-3:7003',
  'redis_slave-1:8001',
  'redis_slave-2:8002',
  'redis_slave-3:8003',
]);

var_dump($redisCluster);

$redisCluster->set('key', 1);
echo $redisCluster->get('key');
