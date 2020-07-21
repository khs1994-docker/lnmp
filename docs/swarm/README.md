# Docker Swarm

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)


**[在生产环境请尽可能使用 `kubernetes`](../kubernetes)**

这里以三节点 `Swarm 集群` 为例。

# 开发环境

**1.** 要想在生产环境部署，当然先得在开发环境制作好镜像

**2.** 编写 `PHP` 项目源代码（项目中可以必须包含 `Dockerfile`）及 `nginx` 配置文件(可选)

**3.** 本地测试

**4.** 将 `PHP` 项目源代码推送到 GitHub， CI/CD 构建 `php` + `nginx` 镜像

**5.** 编写生产环境 `nginx` 配置文件，并推送到 GitHub，CI/CD 调用 Swarm mode 或 k8s API 完成密钥更新

**6.** 服务器拉取镜像，服务更新完成（CI/CD 自动部署）

这样生产环境需要的 Docker 镜像就准备好了。

## 本地测试构建镜像

以下为本地测试镜像步骤。

执行以下命令构建镜像并运行。

```bash
$ docker-compose -f docker-production.yml build [SERVICE_NAME]

$ docker-compose -f docker-production.yml push SERVICE_NAME
```

# 准备

`docker-compose` 与 `Swarm` 启动的容器相互冲突，请清除之后再使用另一种方式。

>网络名称不同也可以，这里为了方便直接清除！

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
$ docker stack deploy -c docker-production.yml lnmp
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

# 服务更新

```bash
$ docker config create nginx_khs1994_com_conf_v2 config/nginx/khs1994.com.conf

$ docker service update \
    --config-rm nginx_khs1994_com_conf \
    --config-add source=nginx_khs1994_com_conf_v2,target=/etc/nginx/conf.d/khs1994.com.conf \
    lnmp_nginx

$ docker secret create khs1994_com_ssl_crt_v2 config/nginx/ssl/khs1994.com.crt

$ docker service update \
    --secret-rm khs1994_com_ssl_crt \
    --secret-add source=khs1994_com_ssl_crt_v2,target=/etc/nginx/conf.d/ssl/khs1994.com.crt \
    lnmp_nginx
```
