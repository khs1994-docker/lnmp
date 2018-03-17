# Redis 集群版(By Ruby)

在 `./cluster/.env` 文件中设置 `REDIS_HOST` `MYSQL_HOST` 变量为 路由器分配给电脑的 IP，或者集群 IP

```bash
# 自行调整配置 ./cluster/redis/redis.conf

# 启动，--build 参数表示每次启动前强制构建镜像 -d 表示后台运行

$ ./lnmp-docker.sh clusterkit-redis-up [-d]

#
# 提示
#
# $ redis-cli -c ... 客户端使用 redis 集群，登录时必须加 -c 参数。
#
# 如果你需要进入节点执行命令
#
# $ ./lnmp-docker.sh clusterkit-redis-exec master1 sh
#

# 销毁集群

$ ./lnmp-docker.sh clusterkit-redis-down [-v]
```

## Swarm mode

# PHP 连接集群
