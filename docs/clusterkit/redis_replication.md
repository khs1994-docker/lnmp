# Redis 主从版 (M-S) 复制模式 replication

在 `docker-cluster.redis.replication.yml` 中定义。

主负责写，从负责读。

从节点只有读权限，不能 **写入** 数据。

## 开发环境

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_M_S_HOST` 变量为路由器分配给电脑的 IP，或者集群 IP

```bash
$ ./lnmp-docker clusterkit-redis-replication-up [-d]

$ ./lnmp-docker clusterkit-redis-replication-down [-v]
```

## Swarm mode

```bash
$ export CLUSTERKIT_REDIS_M_S_HOST=192.168.199.100 # 自行替换为你自己的 IP

$ ./lnmp-docker clusterkit-redis-replication-deploy

$ ./lnmp-docker clusterkit-redis-replication-remove
```

## PHP 连接集群

### predis

* https://github.com/predis/predis#replication

```php
$parameters = [
  'tcp://192.168.199.100:22000?alias=master',
  'tcp://192.168.199.100:23000',
  ];

$options = ['replication' => true];

$client = new Predis\Client($parameters, $options);
```

### Laravel

```bash
'redis' => [

    'client' => 'phpredis',

    'default' => [
        'host' => env('REDIS_HOST', 'localhost'),
        'password' => env('REDIS_PASSWORD', null),
        'port' => env('REDIS_PORT', 6379),
        'database' => 0,
    ],

    'write' => [
        'host' => '192.168.199.100',
        'password' => env('REDIS_PASSWORD', null),
        'port' => 22000,
        'database' => 0,
    ],
    'read' => [
        'host' => '192.168.199.100',
        'password' => env('REDIS_PASSWORD', null),
        'port' => 23000,
        'database' => 0,
    ],
],
```

```php
$redis = Redis::connection('write');
$redis->set('foo','bar');

$redis = Redis::connection('read');
echo $redis->get('foo');
```
