
首先停止使用 docker-compose 启动的容器并移除网络

```bash
$ docker-compose down

$ docker network prune
```

初始化集群

```bash
$ docker swarm init

# 其他节点使用命令加入集群
```

管理节点使用如下命令

```bash
$ docker stack deploy -c docker-compose.swarm.yml lnmp
```

查看

```bash
$ docker stack ls

$ docker stack ps lnmp

$ docker service ls

$ docker service ps lnmp_mysql
```
