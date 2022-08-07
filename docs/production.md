# 配置

假设在 `开发环境` 中已经将 PHP 项目测试完毕，并推送到了 `git`，准备在生产环境部署。

## 生产环境注意事项

在生产环境中建议使用 `Docker Swarm mode` 或 `k8s`。

## 单机

单机环境中通过 `数据卷` 将 `项目文件` 挂载到容器中。

将 PHP 项目克隆到 `./app` 目录下，之后使用 `lnmp-composer ...` 安装依赖。

在 `./config/nginx/*.conf` 增加 nginx 配置。

执行 `./lnmp-docker swarm-deploy`。

## 集群

* 直接将 PHP 项目打入镜像，以容器方式 (`Dockerfile`) 交付。可以参考 [Laravel Demo](https://github.com/khs1994-docker/laravel-demo)

* PHP 项目不打入镜像，运行 daemonset 保证每个节点都有代码文件。

## PHP

生产环境不启用 `xdebug` 扩展

## phpMyAdmin

生产环境不启用该软件。

## Docker 私有仓库

Docker 镜像分发可以使用 Docker 私有仓库。
