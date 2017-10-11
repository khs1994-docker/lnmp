# 生产环境

## PHP

* 不启用 `xdebug`

## 个性化配置

本项目实际只是一个 PHP 程序的运行环境，PHP 项目文件位于 `./app`，nginx 配置文件位于 `./config/nginx/` 为 git 子模块，默认为空文件夹。

使用 git 来拉取项目到 `./app` 内即可，nginx 配置文件同理。这需要根据实际情况自定义 `./bin/production-init`，以实现项目的持续集成/持续部署(CI/CD)。

## Docker 私有仓库

自己构建镜像，推送到私有仓库，生产环境从 Docker 私有仓库拉取镜像。

# 裸机配置

安装 `Docker`

配置 `Docker 加速器`

安装 `docker-compose`

自定义 `./bin/production-init`，拉取 `项目文件`、`nginx 配置文件`

执行 `./lnmp-docker.sh production`
