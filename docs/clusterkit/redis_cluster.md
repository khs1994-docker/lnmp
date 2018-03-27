# Redis 集群版(By Ruby)

销毁之后，不能恢复。

每个节点数据必须为空，才能建立集群。

```bash
>>> Creating cluster
[ERR] Node 192.168.57.110:7001 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0.
```

## 开发环境

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_HOST` 变量为路由器分配给电脑的 IP，或者集群 IP

```bash
# 自行调整配置 ./cluster/redis/redis.conf

# 启动，--build 参数表示每次启动前强制构建镜像 -d 表示后台运行

$ ./lnmp-docker.sh clusterkit-redis-up [--build] [-d]

#
# 提示
#
# $ redis-cli -c ... 客户端使用 redis 集群，登录时必须加 -c 参数。
#
# 如果你需要进入节点执行命令
#
# $ ./lnmp-docker.sh clusterkit-redis-exec redis_master-1 sh
#

# 销毁集群

$ ./lnmp-docker.sh clusterkit-redis-down [-v]
```

## Swarm mode

```bash
# 建议写入到 /etc/profile 文件

$ export CLUSTERKIT_REDIS_HOST=192.168.199.100 # 自行替换为自己的 IP

$ ./lnmp-docker.sh clusterkit-redis-deploy

$ ./lnmp-docker.sh clusterkit-redis-remove
```

## PHP 连接集群
