# Redis 哨兵版（S）

在 `docker-cluster.redis.sentinel.yml` 中定义。

## 开发环境

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_S_HOST` 变量为路由器分配给电脑的 IP，或者集群 IP

```bash
$ ./lnmp-docker.sh clusterkit-redis-sentinel-up [-d]

$ ./lnmp-docker.sh clusterkit-redis-sentinel-down [-v]
```

## Swarm mode

```bash
# 建议写入到 /etc/profile 文件

$ export CLUSTERKIT_REDIS_S_HOST=192.168.199.100 # 自行替换为自己的 IP

$ ./lnmp-docker.sh clusterkit-redis-sentinel-deply

$ ./lnmp-docker.sh clusterkit-redis-sentinel-remove
```

## PHP 连接集群
