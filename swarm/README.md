# Run LNMP ON Swarm mode

## 开发环境

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

## 生产环境集群部署

```bash
# 克隆本项目

# 在本项目根目录执行

$ docker stack deploy -c docker-stack.yml lnmp
```
