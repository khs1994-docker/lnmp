# Run LNMP ON Swarm mode

## 开发环境

编写 PHP 项目源代码(必须包含 `Dockerfile`)

本地测试

推送到 GitHub，CI/CD 系统进行镜像构建，之后部署到生产环境。

## 本地构建镜像

你也可以在本地构建镜像。在 `./swarm` 目录下修改 `docker-compose.yml` 的构建路径及镜像名称，并执行以下命令构建并推送镜像。

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
