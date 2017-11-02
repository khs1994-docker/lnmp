# 生产环境

>请首先在 `开发环境` 中熟悉本项目的使用方法（包括但不限于项目路径，nginx 配置）。

服务器安装 `Docker`

服务器配置 `Docker 加速器`

服务器安装 `docker-compose`

[`Fork` 本项目](https://github.com/khs1994-docker/lnmp/fork)，删除 `dev` 分支

`克隆` 你 Fork 的项目到服务器。

```bash
$ git clone git@github.com:yourname/lnmp.git
$ cd lnmp
# 将项目与上游关联
$ git remote add source git@github.com:khs1994-docker/lnmp.git
```

按需修改，包括你需要启用的软件( `docker-compose.yml` )，`CI/CD`，等。更多信息请阅读 `个性化配置` 一节

执行 `./lnmp-docker.sh production`

>生产环境追求稳定，本项目每月发布一个版本，你只需每月在某天 `同步` 本项目即可。

在服务器命令行操作

```bash
$ git fetch source
$ git rebase source/master
$ git push -f origin/master
```

你也可以在网页上操作，在你项目的 PR 页面点击 `New pull request`。

`base fork` 选择你的仓库，不出意外的话页面会发生改变，你只需点击上边的 `compare across fork` 页面就会跳转回来。

之后 `head fork` 选择 `khs1994-docker/lnmp`，点击 `Create pull request`，填写信息。



## PHP

* 不启用 `xdebug` 扩展

## 个性化配置

本项目实际只是一个 PHP 程序的运行环境，PHP 项目文件位于 `./app`，nginx 配置文件位于 `./config/nginx/` 为 git 子模块，默认为空文件夹。

使用 git 来拉取项目到 `./app` 内即可，nginx 配置文件同理。这需要根据实际情况自定义 `./bin/production-init`，以实现项目的持续集成/持续部署(CI/CD)。

## Docker 私有仓库

你可以自己构建镜像，推送到私有仓库，生产环境从 Docker 私有仓库拉取镜像。
