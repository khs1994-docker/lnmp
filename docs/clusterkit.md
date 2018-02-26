# 集群部署

以下命令均在项目根目录执行，切勿在此目录内执行

## MySQL

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

## Redis

```bash
# 自行调整配置

$ ./lnmp-docker.sh clusterkit-redis-up [--build] [-d]

$ ./lnmp-docker.sh clusterkit-redis-exec master1 sh

$ /docker-entrypoint.sh

# 输入 yes

$ redis-cli -c

127.0.0.1:6379> set ket 1
-> Redirected to slot [8534] located at 172.16.0.102:7002
OK

127.0.0.1:6379> CLUSTER NODES
0d6bba69539e66ae89e4a107c069bb8792f6f900 172.16.0.102:7002@17002 master - 0 1519629667258 2 connected 5461-10922
5ed17ccaf6329f890b42bc3a667c6f2d4f4a4b73 172.16.0.103:7003@17003 master - 0 1519629667000 3 connected 10923-16383
27849849f43d38a68ae0f9cd8a6435c98b0b98e7 172.16.0.201:8001@18001 slave 5ed17ccaf6329f890b42bc3a667c6f2d4f4a4b73 0 1519629666252 4 connected
7be3a5c8abbf0177a96aa6d0f5f9b26ff65316d9 172.16.0.203:8003@18003 slave 0d6bba69539e66ae89e4a107c069bb8792f6f900 0 1519629667000 6 connected
81e526a76d9e776affa6c8cbf477d7b09ec1940b 172.16.0.101:6379@16379 myself,master - 0 1519629666000 1 connected 0-5460
db18669543f90ef5fce4efeb1d150e28f462ca68 172.16.0.202:8002@18002 slave 81e526a76d9e776affa6c8cbf477d7b09ec1940b 0 1519629668261 5 connected

# 退出，登录到任意节点

$ redis-cli -c -h redis_node-1 -p 8001

redis_node-1:8001> get key
-> Redirected to slot [12539] located at 172.16.0.103:7003
"1"

# 停止

$ ./lnmp-docker.sh clusterkit-redis-down [-v]
```

### Swarm mode

> Redis 集群暂不支持运行在 Swarm mode

## Memcached
