# Memcached

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 开发环境

```bash
$ ./lnmp-docker clusterkit-memcached-up [-d]

$ ./lnmp-docker clusterkit-memcached-down [-v]
```

## Swarm mode

```bash
$ ./lnmp-docker clusterkit-memcached-deploy

$ ./lnmp-docker clusterkit-memcached-remove
```

## PHP 连接集群

```php
$m=new Memcached();

$m->addServer('memcached',11211);

// 多台服务器

$m->addServers([
  ['127.0.0.1',11211],
  ['127.0.0.2',11211]
]);

```

### Laravel

```php
'memcached' => [
    [
        'host' => '127.0.0.1',
        'port' => 11211,
        'weight' => 50
    ],
    [
        'host' => '127.0.0.2',
        'port' => 11211,
        'weight' => 50
    ]
],
```
