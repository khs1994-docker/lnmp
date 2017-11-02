# 开发环境

## 构建镜像

请运行如下命令：

```bash
$ ./lnmp-docker.sh devlopment-build

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.10 x86_64 With Build Docker Image

development

```

## 开发过程

首先 [`Fork` 本项目](https://github.com/khs1994-docker/lnmp/fork)，删除 `dev` 分支，`克隆` 你 Fork 的项目到本机，通过 `PR` 保持与上游(本项目)的同步

这一过程具体请查看 [生产环境配置](production.md)

之后 PhpStorm 打开本项目，克隆已有的 PHP 项目文件到 `./app` 目录下或在 `./app` 目录下开始新的开发。

在 `./config/nginx/` 新建 nginx 配置文件

### 使用 Composer

`./lnmp-docker.sh composer` 交互式填入项目路径，要执行的命令，进行依赖的安装或升级

### 命令行执行 PHP 文件

路径为相对于 `./app` 的目录名。

```bash
$ ./lnmp-docker.sh php blog index.php
```
