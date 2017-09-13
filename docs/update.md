## 升级

本项目容器全部基于 `tag:latest`，重新构建镜像请运行以下命令

```bash
$ docker-compose down

$ docker images | grep lnmp

$ docker rmi lnmp-mysql lnmp-redis lnmp-php lnmp-nginx

$ docker-compose build
```
