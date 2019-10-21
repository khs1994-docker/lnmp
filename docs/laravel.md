# Laravel 最佳实践

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 安装 Laravel

```bash
$ cd app

$ lnmp-laravel new laravel
```

具体请查看 [这里](command.md)

### Laravel 版本问题

由于本项目的 PHP 镜像内置的是 Laravel 安装器，而安装器只能安装最新版本 `6.x`。

所以如果你想要安装 `5.5.x` LTS 版本请使用 [`lnmp-laravel-by-composer`](command.md) 安装。

```bash
$ cd app

# $ lnmp-laravel-by-composer new FOLDER VERSION

$ lnmp-laravel-by-composer new laravel5.5 5.5
```

或者直接使用 `composer` 安装

```bash
$ cd app

$ lnmp-composer create-project laravel/laravel laravel5.5 "5.5.*"
```

## 设置 Laravel .env 文件

正确配置服务的 `HOST`，填写 `127.0.0.1` 将连接不到服务，具体原因不再赘述。

```bash
DB_HOST=mysql

REDIS_HOST=redis

MEMCACHED_HOST=memcached
```

## Windows 运行 Laravel 响应缓慢的问题

原因：监听宿主机目录通过 NFS 实现，性能存在问题。

* Docker Desktop 上 Docker 运行在虚拟机，项目文件位于 Windows
* Docker WSL2 上 Docker 运行在 WSL2(仍然是虚拟机)，项目文件位于 Windows

以上两种情况均为跨主机, 故存在性能问题。

解决思路：`vendor` 目录使用数据卷（数据卷存在于虚拟机中）。[vsCode](https://code.visualstudio.com/docs/remote/containers-advanced#_improving-container-disk-performance) 的说明和笔者提出的方案原理大致相同

编辑 `docker-lnmp.include.yml` 文件，重写默认的 `php` `composer` 配置。

```yaml
version: "3.7"

services:
  # 这里增加的条目会重写本项目的默认配置
  php7:
    &php7
    # vendor 目录使用数据卷
    volumes:
      # 假设 laravel 目录位于 `./app/laravel/`
      - type: volume
        source: laravel_vendor
        target: /app/laravel/vendor
      # 假设还有一个 Laravel 应用位于 `./app/laravel2` 与 `./app/laravel` 版本一致（依赖一致），那么可以共用 vendor 数据卷
      - type: volume
        source: laravel_vendor
        target: /app/laravel2/vendor
      # 假设还有一个 laravel 5.5 应用位于 `./app/laravel5.5`，由于与 `./app/laravel` 版本或依赖不一致，必须使用新的数据卷
      - type: volume
        source: laravel_55_vendor
        target: /app/laravel5.5/vendor

  composer:
    << : *php7

# 定义数据卷
volumes:
  laravel_vendor:
  laravel_57_vendor:
```

修改之后启动

```bash
$ lnmp-docker up
```

在容器中运行 composer ，安装依赖

```bash
# $ lnmp-docker composer LARAVEL_ROOT COMPOSER_COMMAND
$ lnmp-docker composer /app/laravel install
```

以后若在 `composer.json` 中添加依赖，重复上述步骤。

## 运行 Laravel 队列(Queue)

使用 **宿主机** 的系统级的守护程序（systemd 等）来运行以下命令。具体请查看 [systemd](systemd.md)

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan queue:work --tries=3
```

## 运行 Laravel 调度器(Schedule)

使用 **宿主机** 的系统级的计划任务（systemd、crontab 等）执行以下命令即可

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan schedule:run
```
