# ClusterKit

`ClusterKit` 的目标是使用 Docker 部署 `MySQL` `Redis` `Memcached` 集群。

以下命令均在项目根目录执行，切勿在此目录内执行，随后我们使用命令行测试集群功能。

PHP 连接集群的方法在最后会做介绍。

## 环境说明

### 开发环境

使用 Docker 桌面版（`Docker For Mac` 或者 `Docker For Windows`）。

或者你可能使用的 `Linux` 系统。

总而言之，假设开发环境你只有 **一台机器**。

开发环境中的集群我们都在 **一台机器** 上启动。

### 生产环境

使用 `Swarm mode` 或 `k8s` 部署。

`Mysql` 一个集群。

`Redis` 一个集群。

`Memcached` 一个集群。

### 开放端口

* Mysql 一主 `13306` 两从 `13307 13308`

* Redis **集群版** 三主 `7001-7003` 三从 `8001-8003`

* Redis **主从版** 一主 `6000` 一从 `6001`

## MySQL

一主两从集群（主负责写，两从负责读）

```bash
# 创建集群，若加上 -d 参数表示后台运行。

$ ./lnmp-docker.sh clusterkit-mysql-up [-d]

# 销毁集群，若加上 -v 参数会销毁数据卷。

$ ./lnmp-docker.sh clusterkit-mysql-down [-v]
```

### Swarm mode

```bash
# 创建集群

$ ./lnmp-docker.sh clusterkit-mysql-deploy

# 销毁集群

$ ./lnmp-docker.sh clusterkit-mysql-remove
```

## Redis 集群版

> Redis 多节点部署包括 集群版 及 主从版，注意不要混淆

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_HOST_IP` `CLUSTERKIT_MYSQL_HOST_IP` 变量为 路由器分配给电脑的 IP

```bash
# 自行调整配置 ./cluster/redis/redis.conf

# 启动，--build 参数表示每次启动前强制构建镜像 -d 表示后台运行

$ ./lnmp-docker.sh clusterkit-redis-up [--build] [-d]

# 手动创建集群

$ ./lnmp-docker.sh clusterkit-redis-create

# 输入 yes

#
# 提示
#
# $ redis-cli -c ... 命令行登录必须加 -c 参数。
#
# 如果你需要进入节点执行命令
#
# $ ./lnmp-docker.sh clusterkit-redis-exec master1 sh
#


# 销毁集群

$ ./lnmp-docker.sh clusterkit-redis-down [-v]
```

### Swarm mode

## Redis 主从版

在 `docker-redis.yml` 中定义。

主负责写，从负责读。

## Memcached

# PHP 连接集群

以上启动一个集群是没有任何意义的，我们要让 PHP 连接到并可以使用集群才有意义。

## 开发环境

在 `.env` 文件中设置 `CLUSTERKIT_REDIS_HOST_IP` `CLUSTERKIT_MYSQL_HOST_IP` 变量为 路由器分配给电脑的 IP

```bash
$ ./lnmp-docker.sh clusterkit [-d] # 加上 -d 参数后台运行

# Redis 集群需要手动创建

$ ./lnmp-docker.sh clusterkit-redis-create

# 输入 yes
```

之后就可以使用 PHP 连接集群了，示例代码位于 `./app/demo/clusterkit-*.php`

PHP 使用 Redis 集群示例代码请查看 [PHPRedis](https://github.com/khs1994-docker/lnmp/blob/master/app/demo/clusterkit-redis.php)

## 生产环境

参见上方 `Swarm mode` 部分。
