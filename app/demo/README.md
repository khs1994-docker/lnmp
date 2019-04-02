# Docker 化 PHP 项目最佳实践(从 docker run 到 helm install ... --tls)

完全使用 Docker 开发、部署 PHP 项目。本指南只是简单列出，具体内容请查看 [文档](https://github.com/khs1994-docker/lnmp/tree/master/docs)

* [问题反馈](https://github.com/khs1994-docker/lnmp/issues/187)

## Create PHP Application by Composer

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/php-demo.svg?style=social&label=Stars)](https://github.com/khs1994-docker/php-demo) [![PHP from Packagist](https://img.shields.io/packagist/php-v/khs1994/example.svg)](https://packagist.org/packages/khs1994/example) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/php-demo/all.svg)](https://github.com/khs1994-docker/php-demo/releases) [![Build Status](https://travis-ci.org/khs1994-docker/php-demo.svg?branch=master)](https://travis-ci.org/khs1994-docker/php-demo) [![StyleCI](https://styleci.io/repos/124168962/shield?branch=master)](https://styleci.io/repos/124168962) [![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

```bash
$ composer create-project --prefer-dist khs1994/example example

$ cd example
```

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## 进阶路线

* `docker run`

* `docker-compose up`

* `kubectl create -f filename.yaml`

* `helm install ./lnmp --tls`

## 说明

* 本项目以 PHP 最新的主线版本 `7.3.3` 为例，如果你需要其他版本，或多种版本请到 https://github.com/khs1994-docker/lnmp/issues/354 反馈

* Laravel 项目，请查看 https://github.com/khs1994-docker/laravel-demo

## 初始化

> 注意本项目专用于 khs1994.com PHP 开源项目，他人使用请按以下步骤进行初始化，严禁直接使用。

* 编辑 `.pcit.php` 文件中的常量

* 执行 `php .pcit.php` 完成替换

### 准备

建立一个自己的 PHP 项目模板（即 `composer` 包类型为 `project`),里面包含了常用的文件的模板。

示例：https://github.com/khs1994-docker/php-demo

#### 内置文件模板

* 建议多看看几个 PHP 开源项目，看看别人的项目里都有哪些文件，作用是什么

| Filename          | Description                     |
| :-------------    | :-------------                  |
| `.gitattributes`  | git 打包时排除文件（例如 测试代码）|
| `.drone.yml`      | [`Drone` CI 工具](https://github.com/khs1994-docker/ci) |
| `.editorconfig`   | [定义文件格式规则（例如 缩进方式）](https://editorconfig.org/)|
| `.pcit.yml`       | [`PCIT` CI 工具](https://ci.khs1994.com) |
| `.php_cs`         | [PHP 代码格式化工具](https://github.com/FriendsOfPHP/PHP-CS-Fixer) |
| `.sami.php`       | [PHP 文档生成工具](https://github.com/FriendsOfPHP/Sami) |
| `.styleci.yml`    | [`Style CI` PHP 代码格式化 CI 工具](https://styleci.io/) |
| `.travis.yml`     | [`Travis` CI 工具](https://www.travis-ci.com) |

## 一、开发

### 环境（以下步骤缺一不可）

* 假设系统中不包含任何 PHP 等程序（实际上为了防止 Docker 崩溃等意外情况，建议系统中仍然安装这些软件作为 PLAN B）

* 启动 Docker CE

* LNMP [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp)

* 将 Docker 化的常用命令所在文件夹加入 `PATH`，具体请查看 [这里](https://github.com/khs1994-docker/lnmp/tree/master/bin)。

* IDE `PHPStorm`

* git 分支 `dev`

* 使用 Docker 作为 LNMP 环境，实际上大大简化了部署，但配置开发环境需要较多步骤，同时由于 Windows(性能特别差)、macOS（还可以） 运行 Docker 效率较 Linux 差，实际在开发环境是否使用 Docker，请各位自行权衡。

### 1. 新建 PHP 项目

使用自己的模板项目初始化 `PHP` 项目并初始化 git 仓库。

```bash
$ cd lnmp/app

$ lnmp-composer create-project --prefer-dist khs1994/example:dev-master example

$ cd example

$ git init

$ git remote add origin git@url.com:username/EXAMPLE.git

$ git checkout -b dev

$ echo -e "<?php\nphpinfo();" >> index.php
```

### 2. 新增 NGINX 配置

一个 **PHP 项目**， 一个 **网址**，一个 **NGINX 子配置文件**

参考示例配置文件在 `config/nginx` 新建 `*.conf` NGINX 配置文件

### 3. 启动 khs1994-docker/lnmp

```bash
$ ./lnmp-docker up

# $ ./lnmp-docker restart
```

### 4. 浏览器验证

浏览器打开页面出现 php 信息

### 5. PHPStorm 打开 PHP 项目

注意打开的是 PHP 项目（避免文件层次过深，IDE 直接打开 PHP 项目），不是 `khs1994-docker/lnmp`！

要配置 `khs1994-docker/lnmp` 建议使用另外的文本编辑器。

> 你可以通过设置 [`APP_ROOT`](https://github.com/khs1994-docker/lnmp/blob/master/docs/development.md#app_root) 变量来实现 `app` 与 `khs1994-docker/lnmp` 并列。

### 6. CLI settings

由于 PHP 环境位于 Docker 中，必须进行额外的配置

`PHPStorm 设置`-> `Languages & ...` -> `PHP` -> `CLI Interpreter` -> `点击后边三个点`
     -> `左上角添加` -> `From Docker ...` -> `选择 Docker`
     -> `Image name` -> `选择 khs1994/php:7.2.x-fpm-alpine`
     -> `点击 OK 确认`

点击 ok 之后跳转的页面上 `Additionl` -> `Debugger extension`-> 填写 `xdebug`

具体请查看 https://github.com/khs1994-docker/lnmp/issues/260#issuecomment-373964173

再点击 ok 之后跳转到了 `PHPStorm 设置`-> `Languages & ...` -> `PHP` -> `CLI Interpreter` 这个页面

#### 配置路径对应关系

这里以 Windows 为例，其他系统同理（添加本机路径与容器路径对应关系即可）。

由于 Windows 与 Linux 路径表示方法不同，我们必须另外添加对应关系。配置容器目录与本地项目之间的对应关系。

假设本地项目目录位于 `C:/Users/username/app/example` 对应的容器目录位于 `/app/example`

点击 `Path mappings` 添加一个条目 `C:/Users/username/app/example` => `/app/example`

#### 配置容器其他参数

点击 `Docker container` 后边三个点配置容器的参数（就像 docker run ... 命令行配置的参数一样）

* Network mode `lnmp_backend` (非常重要)

* Volume bindings -> Container path `/app/PHP_PROJECT`, Host path 保持不变，需要挂载其他文件再新增一个条目即可

* 其他参数根据实际需要自行配置

### 7. 设置 Xdebug

请查看 https://github.com/khs1994-docker/lnmp/blob/master/docs/xdebug.md

### 8. 引入 Composer 依赖

容器化 PHPer 常用命令请查看 https://github.com/khs1994-docker/lnmp/blob/master/docs/command.md

```bash
# 引入依赖
$ lnmp-composer require phpunit/phpunit

# 或安装依赖
$ lnmp-composer install [--ignore-platform-reqs]
```

### 9. 编写 PHP 代码

### 10. 编写 PHPUnit 测试代码

### 11. 使用 PHPUnit 测试

#### 使用 PHPStorm

`PHPStorm 设置`-> `Languages & ...` -> `PHP` ->`Test Frameworks` -> `左上角添加`
              -> `PHPUnit by Remote Interpreter` -> `选择第五步添加的 Docker 镜像`
              -> `点击 OK` -> `PHPUnit Library` -> `选择 Use Composer autoloader`
              -> `Path to script` -> 点击右边刷新按钮即可自动识别，或者手动 `填写 /app/PHP_PROJECT/vendor/autoload.php`
              -> `点击 OK 确认`

在测试函数名单击右键 `run FunName` 开始测试。

#### 使用命令行

```bash
$ cd lnmp/app/PHP_PROJECT

# 根目录必须包含 PHPUnit 配置文件 phpunit.xml
$ lnmp-phpunit [参数]
```

### 12. 本地测试构建 PHP 及 NGINX 镜像

此示例将 PHP 代码打入了镜像中，如果你选择将代码放入宿主机，那么无需进行此步骤。两种方法自行取舍。

关于代码放到哪里？代码放入宿主机，上线时需要人工在服务器 pull 代码。放入镜像中，上线时直接拉取镜像之后启动容器，无需人工干预。

> 将 PHP 项目打入镜像，镜像中严禁包含配置文件

> 最佳实践：Docker 镜像由 CI 服务器构建，而不是本地人工构建！

自行修改 `.env` `docker-compose.yml` 文件，保留所需的 PHP 版本，其他的注释

```bash
$ docker-compose build php72 nginx
```

### 13. 将项目提交到 Git

```bash
$ git add .

$ git commit -m "First"

$ git push origin dev:dev
```

## CI/CD 服务搭建

CI/CD 可以到 [khs1994-docker/ci](https://github.com/khs1994-docker/ci) 查看。

* Travis CI (公共的、仅支持 GitHub CI/CD)

* Drone (私有化 CI/CD)

* PCIT (开发中，支持各种开发语言，特别为 PHP 设计的基于容器的 CI/CD 系统)

## 二、测试（全自动）

### CI/CD 服务器收到 Git Push 事件，进行代码测试

## 三、开发、测试循环

## 四、在 Kubernetes 中部署生产环境 (全自动)

> 可以在生产环境之前加一个 **预上线** 环境，这里省略。

### 1. git 添加 tag，并推送到远程仓库

### 2. CI/CD 服务器收到 Git Tag 事件，自动构建镜像并推送镜像到 Docker 仓库。

### 3. CI/CD 服务器中使用 Helm 在 k8s 集群更新服务

* https://github.com/khs1994-docker/lnmp-k8s/tree/master/helm
