# Redis 集群版 (redis-cli --cluster)

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

5.0 move `ruby` to `redis-cli --cluster`

More information please exec `$ redis-cli --cluster help`

每个节点数据必须为空，才能建立集群。

```bash
>>> Creating cluster
[ERR] Node 192.168.57.110:7001 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0.
```

## Redis 集群的主从复制模型

为了使在部分节点失败或者大部分节点无法通信的情况下集群仍然可用，所以集群使用了主从复制模型，每个节点都会有 N-1 个复制品。

在例子中具有 A，B，C 三个节点的集群，在没有复制模型的情况下，如果节点B失败了，那么整个集群就会以为缺少 5501-11000 这个范围的槽而不可用。

然而如果在集群创建的时候（或者过一段时间）为每个节点添加一个从节点 A1,B1,C1 那么整个集群便有三个 master 节点和三个 slave 节点组成，这样在节点B失败后，集群便会选举B1为新的主节点继续服务，整个集群便不会因为槽找不到而不可用了

不过当 B 和 B1 都失败后，集群是不可用的.

## 开发环境

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_HOST` 变量为路由器分配给电脑的 IP，或者集群 IP

```bash
# 自行调整配置 ./cluster/redis/redis.conf

# -d 表示后台运行

$ ./lnmp-docker clusterkit-redis-up [-d]

#
# 提示
#
# $ redis-cli -c ... 客户端使用 redis 集群，登录时必须加 -c 参数。
#
# 如果你需要进入节点执行命令
#
# $ ./lnmp-docker clusterkit-redis-exec redis_master-1 sh
#

# 销毁集群

$ ./lnmp-docker clusterkit-redis-down [-v]
```

## Swarm mode

```bash
$ export CLUSTERKIT_REDIS_HOST=192.168.199.100 # 自行替换为自己的 IP

$ ./lnmp-docker clusterkit-redis-deploy

$ ./lnmp-docker clusterkit-redis-remove
```

## PHP 连接集群

### phpredis

* https://github.com/phpredis/phpredis/blob/develop/cluster.markdown

```php
$obj_cluster = new RedisCluster(NULL, [
  'host:7001',
  'host:7002',
  'host:7003',
  'host:8001',
  'host:8002',
  'host:8003',
  ]
);
```

### predis

* https://github.com/predis/predis

* https://github.com/predis/predis#cluster

```php
$parameters = [
  'tcp://192.168.199.100:7001',
  'tcp://192.168.199.100:7002',
  'tcp://192.168.199.100:7003',
  'tcp://192.168.199.100:8001',
  'tcp://192.168.199.100:8002',
  'tcp://192.168.199.100:8003',
];

$options = ['cluster' => 'redis'];

$client = new Predis\Client($parameters, $options);
```

### Laravel

* https://www.cnblogs.com/liaokaichang/p/8874808.html

```php
'redis' => [
    'client' => 'phpredis',
    'default' => [
         'host' => env('REDIS_HOST', '127.0.0.1'),
         'password' => env('REDIS_PASSWORD', null),
         'port' => env('REDIS_PORT', 6379),
         'database' => 0,
    ],
    'mydefine' => [
         'host' => env('REDIS_HOST', '127.0.0.1'),
         'password' => env('REDIS_PASSWORD', null),
         'port' => env('REDIS_PORT', 6379),
         'database' => 0,
    ],

    'options' => [
        'cluster' => 'redis',
    ],

    'clusters' => [
        'mycluster1' => [
            [
                'host' => '127.0.0.1',
                'password' => env('REDIS_PASSWORD', null),
                'port' => 7001,
                'database' => 0,
            ],
            [
                'host' => '127.0.0.1',
                'password' => env('REDIS_PASSWORD', null),
                'port' => 7002,
                'database' => 0,
            ],
            [
                'host' => '127.0.0.1',
                'password' => env('REDIS_PASSWORD', null),
                'port' => 7003,
                'database' => 0,
            ],
            [
                'host' => '127.0.0.1',
                'password' => env('REDIS_PASSWORD', null),
                'port' => 8001,
                'database' => 0,
            ],
            [
                'host' => '127.0.0.1',
                'password' => env('REDIS_PASSWORD', null),
                'port' => 8002,
                'database' => 0,
            ],
            [
                'host' => '127.0.0.1',
                'password' => env('REDIS_PASSWORD', null),
                'port' => 8003,
                'database' => 0,
            ],
       ],
    ],
],
```

```php
$redis = Redis::connection('mycluster1');

$redis->set('foo','bar');

echo $redis->get('foo');
```

## 参考

* https://www.cnblogs.com/51life/p/10233340.html
