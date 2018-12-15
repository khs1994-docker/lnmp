# 本项目开发 Laravel 最佳实践

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 安装 Laravel

```bash
$ cd app

$ lnmp-laravel new laravel
```

具体请查看 [这里](command.md)

### Laravel 版本问题

由于本项目的 PHP 镜像内置的是 Laravel 安装器，而安装器只能安装最新版本 `5.7.x`。

所以如果你想要安装 `5.5.x` LTS 版本请使用 [`lnmp-laravel5.5`](command.md) 安装。

```bash
$ cd app

$ lnmp-laravel5.5 new laravel5.5
```

或者直接使用 `composer` 安装

```bash
$ cd app

$ lnmp-composer create-project laravel/laravel laravel5.5 "5.5.*"
```

## Windows 运行 Laravel 响应缓慢的问题

原因：监听宿主机目录通过 NFS 实现，性能存在问题。

解决思路：`vendor` 目录使用数据卷（数据卷存在于虚拟机中）。

编辑 `docker-compose.include.yml` 文件，重写默认的 `php` 配置。

```yaml
version: "3.7"

services:
  # 这里增加的条目会重写本项目的默认配置
  php7:
    # 本项目默认的 php 镜像不包含 composer，所以我们这里使用 composer 镜像
    image: khs1994/php:7.3.0-composer-alpine
    # vendor 目录使用数据卷
    volumes:
      # 假设 laravel 目录位于 `./app/laravel/`
      - laravel_vendor:/app/laravel/vendor
      # 假设还有一个 Laravel 应用位于 `./app/laravel2` 与 `./app/laravel` 版本一致（依赖一致），那么可以共用 vendor 数据卷
      - laravel_vendor:/app/laravel/vendor2
      # 假设还有一个 laravel 5.7 应用位于 `./app/laravel5.7`，由于与 `./app/laravel` 依赖不一致，必须使用新的数据卷
      - laravel_57_vendor:/app/laravel5.7/vendor

# 定义数据卷
volumes:
  laravel_vendor:
  laravel_57_vendor:
```

修改之后启动

```bash
$ lnmp-docker up
```

进入命令行安装依赖

```bash
$ lnmp-docker php7-cli

$ cd /app/laravel/

$ composer install

# $ composer update

# 以此类推，进入其他 Laravel 的目录，安装依赖。
```

## 运行 Laravel 队列(Queue)

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan queue:work --tries=3
```

生产环境中使用 **宿主机** 的系统级的守护程序（systemd）来保证上边的命令运行。具体请查看 [systemd](systemd.md)

## 运行 Laravel 调度器(Schedule)

使用 **宿主机** 的系统级的计划任务（systemd、crontab,etc）执行以下命令即可

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan schedule:run
```
