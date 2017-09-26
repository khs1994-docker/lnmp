# 命令行工具简要说明

为避免输入过多的命令，编写了命令行工具简化用户使用。

提供了以下功能：

* 各种场景和架构中一键启动、停止或者销毁项目

* 安装 Laravel 项目

* 使用 Laravel artisan

* 使用 Composer

* 生产环境使用 Composer 安装 PHP 项目依赖包

## 详解

使用 `docker-compose` 来启动、停止、销毁容器的参数分别是 `up -d` `stop` `down`，通过 `-f` 来加载 `docker-compose.yml`(可以任意命名，也可以是 json 格式)。

本项目的 CLI 就是对以上一些命令的封装，本人的 shell 掌握的不够深入，写的比较粗糙，大家应该都能读懂。
