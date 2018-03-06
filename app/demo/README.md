# Docker 化 PHP 项目最佳实践

完全使用 Docker 开发、部署 PHP 项目

* [问题反馈](https://github.com/khs1994-docker/lnmp/issues/187)

## 开发

### 环境

* LNMP [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp)

* IDE `PHPStorm`

### 1.新建 PHP 项目

```bash
$ cd lnmp

$ mkdir -p app/demo

$ echo -e "<?php\nphpinfo();" >> app/demo/index.php
```

### 2.新增 NGINX 配置

参考示例配置文件在 `config/nginx` 新建 `php.conf` NGINX 配置文件

### 3.启动 khs1994-docker/lnmp

```bash
$ ./lnmp-docker.sh development
```

### 4.浏览器验证

浏览器打开页面，出现 php 信息

### 5.PHPStorm 打开已有项目

### 6.设置 CLI

`PHPStorm 设置`-> `Languages & ...` -> `PHP` -> `CLI Interpreter` -> `点击后边三个点`
     -> `左上角添加` -> `From Docker ...` -> `Remote` -> `选择 Docker`
     -> `Image name` -> `选择 khs1994/php-fpm:7.2.3-alpine3.7`
     -> `点击 OK 确认`

### 7.设置 xdebug

请查看 https://github.com/khs1994-docker/lnmp/blob/master/docs/xdebug.md

### 8.引入 Composer 依赖

容器化 PHPer 常用命令请查看 https://github.com/khs1994-docker/lnmp/blob/master/docs/command.md

```bash
$ lnmp-composer require phpunit/phpunit
```

### 9.编写 PHP 代码

### 10.编写 PHPUnit 测试代码

### 11.使用 PHPUnit 测试

#### 使用 PHPStorm

`PHPStorm 设置`-> `Languages & ...` -> `PHP` ->`Test Frameworks` -> `左上角添加`
              -> `PHPUnit by Remote Interpreter` -> `选择第五步添加的 Docker 镜像`
              -> `点击 OK` -> `PHPUnit Library` -> `选择 Use Composer autoloader`
              -> `Path to script` -> `填写 /opt/project/vendor/autoload.php`
              -> `点击右边刷新` -> `点击 OK 确认`


在测试函数名单击右键 `run FunName` 开始测试。

#### 使用命令行

```bash
$ lnmp-phpunit
```

### 12.测试构建 PHP 及 NGINX 镜像

自行修改 `.env` `docker-compose.yml` 文件，保留所需的 PHP 版本，其他的注释

```bash
$ docker-compose build
```

### 13.将项目提交到 Git

```bash
$ git init

$ git add .

$ git commit -m "First"

$ git remote add origin GIT_URL

$ git push origin master
```

## 测试（全自动）

### 1.Git 通知到 CI/CD 服务器

* Travis CI (公共的、仅支持 GitHub CI/CD)

* Drone (私有化 CI/CD)

### 2. CI/CD 服务器测试

## 开发、测试循环

## git 添加 tag

只有添加了 `tag` 的代码才能部署

Docker 镜像名包含 git `tag`

## 部署 (全自动)

生产环境部署 [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp) 请查看 https://github.com/khs1994-docker/lnmp/tree/master/docs/production

### 1. CI/CD 服务器构建 Docker 镜像

### 2. CI/CD 服务器推送 Docker 镜像到私有 Docker 仓库

### 3.Docker 私有仓库通知到指定地址

### 4.Swarm mode 或 k8s 集群自动更新服务

### 5.完成部署
