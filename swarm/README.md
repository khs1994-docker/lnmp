# Run LNMP ON Swarm mode

## 开发环境

编写 PHP 项目源代码

本地测试

推送到 GitHub

构建镜像（镜像中包含 PHP 项目文件）

```bash
# 在 ../dockerfile/* 编写 Dockerfile.swarm

# 在当前目录执行

$ docker-compose build

$ docker-compose push
```

## 生产环境集群部署

```bash
# 克隆本项目

# 在本项目根目录执行

$ docker stack deploy -c docker-stack.yml lnmp
```
