# 配置

将 PHP 项目 `git 克隆` 到 `./app` 目录下，配置 `./config/nginx/*.conf`。

执行 `./lnmp-docker.sh production`

## PHP

* 生产环境不启用 `xdebug` 扩展

## Docker 私有仓库

你可以自己构建镜像，推送到私有仓库，生产环境从 Docker 私有仓库拉取镜像。
