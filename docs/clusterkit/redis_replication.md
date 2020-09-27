# Redis 主从版 (M-S) 复制模式 replication

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

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
