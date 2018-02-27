<?php

// $redisCluster=new RedisCluster(null,[
//   '192.168.199.100:7001',
//   '192.168.199.100:7002',
//   '192.168.199.100:7003',
//   '192.168.199.100:8001',
//   '192.168.199.100:8002',
//   '192.168.199.100:8003',
// ]);

// https://github.com/phpredis/phpredis/blob/feature/redis_cluster/cluster.markdown

$redisCluster=new RedisCluster(null,[
  'redis_master-1:7001',
  'redis_master-2:7002',
  'redis_master-3:7003',
  'redis_slave-1:8001',
  'redis_slave-2:8002',
  'redis_slave-3:8003',
]);

var_dump($redisCluster);

$redisCluster->set('key', 1);
echo $redisCluster->get('key');
