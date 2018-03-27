# Redis 主从版 (M-S)

在 `docker-cluster.redis.master.slave.yml` 中定义。

主负责写，从负责读。

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_M_S_HOST` 变量为路由器分配给电脑的 IP，或者集群 IP

```bash
$ ./lnmp-docker.sh clusterkit-redis-master-slave-up [-d]

$ ./lnmp-docker.sh clusterkit-redis-master-slave-down [-v]
```

## Swarm mode

```bash
$ export CLUSTERKIT_REDIS_M_S_HOST=192.168.199.100 # 自行替换为你自己的 IP

$ ./lnmp-docker.sh clusterkit-redis-master-slave-deploy

$ ./lnmp-docker.sh clusterkit-redis-master-slave-remove
```

## PHP 连接集群

PHP 使用 Redis 集群示例代码请查看 [PHPRedis](https://github.com/khs1994-docker/lnmp/blob/master/app/demo/clusterkit-redis.php)
