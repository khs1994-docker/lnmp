这里以三节点 `Swarm 集群` 为例。

# 开发环境

要想在生产环境部署，当然得在开发环境制作好镜像！

编写 PHP 项目源代码

本地测试

推送到 GitHub

构建镜像（镜像中包含 PHP 项目文件）

在 `./dockerfile` 目录下的 `nginx` `php-fpm` 子目录中修改 `Dockerfile.swarm` 文件。

在 `./swarm` 目录下执行

```bash
$ docker-compose build

$ docker-compose push
```

这样生产环境需要的 Docker 镜像就准备好了，当然以上步骤中构建镜像无需手动操作，具体实现请自行探索！

# 准备

`docker-compose` 与 `Swarm` 启动的容器相互冲突，请清除之后再使用另一种方式(网络名称不同也可以，这里为了方便直接清除)！

首先停止使用 `docker-compose` 启动的容器并移除网络

```bash
$ docker-compose down

$ docker network prune
```

# 初始化集群

如果您已经有了一个集群，请跳过此步。

```bash
$ docker swarm init

# 使用如下命令，按照提示在其他节点执行命令以加入集群

$ docker swarm join-token worker

# 或加入管理节点

$ docker swarm join-token manager
```

# 部署服务栈

多个互相关联的服务组成 `服务栈`，在项目根目录执行

```bash
$ docker stack deploy -c docker-stack.yml lnmp
```

## 查看

```bash
$ docker stack ls

# 查看 服务栈 详情

$ docker stack ps lnmp

$ docker service ls

# 查看具体的某个 服务（多个任务「容器」组成一个服务）

$ docker service ps lnmp_mysql
```

# 浏览器图形化展示节点状态

浏览器打开 `ip:8080`

![](../img/docker-swarm-three.png)

## 移除服务栈

```bash
$ docker stack rm lnmp
```
