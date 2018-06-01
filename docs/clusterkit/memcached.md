# Memcached

## 开发环境

```bash
$ ./lnmp-docker.sh clusterkit-memcached-up [-d]

$ ./lnmp-docker.sh clusterkit-memcached-down [-v]
```

## Swarm mode

```bash
$ ./lnmp-docker.sh clusterkit-memcached-deploy

$ ./lnmp-docker.sh clusterkit-memcached-remove
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
