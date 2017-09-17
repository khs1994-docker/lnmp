## 升级

本项目容器全部基于 `tag:latest`，重新构建镜像请运行以下命令

```bash
$ docker-compose down

$ docker images | grep lnmp

$ docker rmi lnmp-php \
             lnmp-postgresql \
             lnmp-mongo \
             lnmp-memcached \
             lnmp-mysql \
             lnmp-rabbitmq \
             lnmp-redis \
             lnmp-nginx

$ docker-compose build

# 重新构建单容器镜像

$ ./build.sh
```
