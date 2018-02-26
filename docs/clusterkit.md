# ClusterKit

`ClusterKit` 的目标是使用 Docker 部署 `MySQL` `Redis` `Memcached` 集群。

以下命令均在项目根目录执行，切勿在此目录内执行，随后我们使用命令行测试集群功能。

PHP 连接集群的方法在最后会做介绍。

## MySQL

一主两从集群（主负责写，两从负责读）

```bash
$ ./lnmp-docker.sh clusterkit-mysql-up [-d]

# 停止

$ ./lnmp-docker.sh clusterkit-mysql-down [-v]
```

### Swarm mode

```bash
$ ./lnmp-docker.sh clusterkit-mysql-deploy

# 停止

$ ./lnmp-docker.sh clusterkit-mysql-remove
```

## Redis 集群版

```bash
# 自行调整配置 ./cluster/redis/redis.conf

# 启动

$ ./lnmp-docker.sh clusterkit-redis-up [--build] [-d]

# 创建集群

$ ./lnmp-docker.sh clusterkit-redis-create

# 输入 yes

#
# 提示
#
# $ redis-cli -c ... 命令行登录必须加 -c 参数。
#
# 如果你需要进入节点执行命令
#
# ./lnmp-docker.sh clusterkit-redis-exec master1 sh
#
# 停止

$ ./lnmp-docker.sh clusterkit-redis-down [-v]
```

### Swarm mode

> Redis 集群暂不支持运行在 Swarm mode

## Redis 主从版

在 `docker-redis.yml` 中定义。

主负责写，从负责读。

## Memcached

# PHP 连接集群

以上启动一个集群是没有任何意义的，我们要让 PHP 连接到并可以使用集群才有意义。

## 开发环境

```bash
$ ./lnmp-docker.sh clusterkit -d # 加上 -d 参数后台运行

# 输入 yes
```

PHP 使用 Redis 集群示例代码请查看 [PHPRedis](https://github.com/khs1994-docker/lnmp/blob/master/app/demo/clusterkit-redis.php)

## 生产环境

>  暂不支持 Redis 集群，只支持 Redis 主从版

```bash
$ ./lnmp-docker.sh swarm-clusterkit

# 停止

$ ./lnmp-docker.sh swarm-down
```
