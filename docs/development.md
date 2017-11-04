# 开发环境

## 开发过程

安装 `Docker` 配置 `Docker 加速器`

```bash
$ git clone -b dev git@github.com:khs1994-docker/lnmp.git
$ cd lnmp
```

修改需要启用的软件 `docker-compose.yml`。

修改镜像前缀、PHP 项目路径 `.env`。

执行 `./lnmp-docker.sh development`。

在 `./config/nginx/` 参考示例配置，新建 nginx 配置文件。

之后 PhpStorm 打开本项目，克隆已有的 PHP 项目文件到 `./app` 目录下或在 `./app` 目录下开始新的开发。

## 更新

```bash
$ git fetch origin
$ git rebase origin/master
$ ./lnmp-docker.sh development
```

### 使用 Composer

`./lnmp-docker.sh composer` 交互式填入项目路径，要执行的命令，进行依赖的安装或升级

### 命令行执行 PHP 文件

路径为相对于 `./app` 的目录名。

```bash
$ ./lnmp-docker.sh php blog index.php
```

## 构建镜像

在 `./dockerfile/` 下修改 `dockerfile` 文件

之后运行如下命令：

```bash
$ ./lnmp-docker.sh devlopment-build

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.10 x86_64 With Build Docker Image

development

```
