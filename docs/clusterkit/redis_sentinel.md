# Redis 哨兵版（S）

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
