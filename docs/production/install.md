# 生产环境

请首先在 [`开发环境`](development.md) 中熟悉本项目的使用方法（包括但不限于项目路径，nginx 配置）。

将 PHP 项目 `git 克隆` 到 `./app` 目录下，配置 `./config/nginx/*.conf`。

执行 `./lnmp-docker.sh production`

## 更新

>生产环境追求稳定，本项目每月第一天发布一个稳定版本，你只需每月第一天 `同步` 本项目即可。

```bash
$ git fetch origin
$ git rebase origin/master
$ ./lnmp-docker.sh production
```

## PHP

* 生产环境不启用 `xdebug` 扩展

## 个性化配置

本项目实际只是一个 PHP 程序的运行环境，PHP 项目文件位于 `./app`，nginx 配置文件位于 `./config/nginx/` 为 git 子模块，默认为空文件夹。

使用 git 来拉取项目到 `./app` 内即可，nginx 配置文件同理。这需要根据实际情况自定义 `./bin/production-init`，以实现项目的持续集成/持续部署(CI/CD)。

## Docker 私有仓库

你可以自己构建镜像，推送到私有仓库，生产环境从 Docker 私有仓库拉取镜像。
