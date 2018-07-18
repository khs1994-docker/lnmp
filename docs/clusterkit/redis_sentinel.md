# Redis 哨兵版 Sentinel

在 `docker-cluster.redis.sentinel.yml` 中定义。

是主从（M-S）的升级版，能够做到自动主从切换。

主负责写，从负责读。

同样的从只有读权限，不能写入数据。

写入数据时必须通过 Sentinel API 动态的获取主节点 IP。

哨兵节点不能写入数据。

销毁之后（不销毁数据卷），再次部署可以恢复。

```bash
# 获取主节点 IP

SENTINEL get-master-addr-by-name $master_name(mymaster)
```

模拟主节点故障，发现过一段时间，某个从节点自动升级为主节点。

## 开发环境

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_S_HOST` 变量为路由器分配给电脑的 IP，或者集群 IP

```bash
$ ./lnmp-docker clusterkit-redis-sentinel-up [-d]

$ ./lnmp-docker clusterkit-redis-sentinel-down [-v]
```

## Swarm mode

```bash
# 建议写入到 /etc/profile 文件

$ export CLUSTERKIT_REDIS_S_HOST=192.168.199.100 # 自行替换为自己的 IP

$ ./lnmp-docker clusterkit-redis-sentinel-deply

$ ./lnmp-docker clusterkit-redis-sentinel-remove
```

## PHP 连接集群

### phpredis

* https://segmentfault.com/a/1190000011185598

```php
//初始化 redis 对象
$redis = new Redis();
//连接 sentinel 服务 host 为 ip，port 为端口
$redis->connect($host, $port);

//可能用到的部分命令，其他可以去官方文档查看

//获取主库列表及其状态信息
$result = $redis->rawCommand('SENTINEL', 'masters');

//根据所配置的主库redis名称获取对应的信息
//master_name应该由运维告知（也可以由上一步的信息中获取）
$result = $redis->rawCommand('SENTINEL', 'master', $master_name);

//根据所配置的主库redis名称获取其对应从库列表及其信息
$result = $redis->rawCommand('SENTINEL', 'slaves', $master_name);

//获取特定名称的redis主库地址
$result = $redis->rawCommand('SENTINEL', 'get-master-addr-by-name', $master_name)

//这个方法可以将以上sentinel返回的信息解析为数组
function parseArrayResult(array $data)
{
    $result = array();
    $count = count($data);
    for ($i = 0; $i < $count;) {
        $record = $data[$i];
        if (is_array($record)) {
            $result[] = parseArrayResult($record);
            $i++;
        } else {
            $result[$record] = $data[$i + 1];
            $i += 2;
        }
    }
    return $result;
}
```

### predis

* https://github.com/nrk/predis

* https://github.com/nrk/predis/issues/503

```php
<?php

use Predis\Client;
use Predis\Session\Handler;

$options = [
    'prefix' => 'session:',
    'replication' => 'sentinel',
    'service' => 'sessions',
    'connections' => [
        'tcp'  => 'Predis\Connection\PhpiredisStreamConnection',
        'unix' => 'Predis\Connection\PhpiredisSocketConnection',
    ],
];

$sentinels = [
    'tcp://192.168.0.1:26379',
    'tcp://192.168.0.2:26379',
    'tcp://192.168.0.3:26379',
];

$client  = new Client($sentinels, $options);
$handler = new Handler($client, ['gc_maxlifetime' => ini_get('session.gc_maxlifetime')]);
$handler->register();
```

### Laravel

* https://github.com/laravel/framework/pull/18850

> 必须使用 predis 包，不能使用 pecl 的 redis 扩展。使用之前先在 php.ini 中注释掉加载 redis 的配置项。

```bash
$ composer require predis/predis
```

```php
'redis' => [
    'client' => 'predis',

    'sentinel' => [
        'tcp://192.168.199.100:21000?timeout=0.100',
        'tcp://192.168.199.100:21001?timeout=0.100',
        'options' => [
            'replication' => 'sentinel',
            'service' => env('REDIS_SENTINEL_SERVICE', 'mymaster'),
            'parameters' => [
                'password' => env('REDIS_PASSWORD', null),
                'database' => 0,
            ],
        ],
    ],
],
```

```php
$redis = Redis::connection('sentinel');
$redis->set('foo','bar');

echo $redis->get('foo');
```
