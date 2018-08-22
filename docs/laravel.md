# 本项目开发 Laravel 最佳实践

请查看 [这里](command.md)

## Laravel 版本问题

由于本项目的 PHP 镜像内置的是 Laravel 安装器，而安装器只能安装最新版本 `5.6.x`。

所以如果你想要安装 `5.5.x` LTS 版本请使用 [`lnmp-laravel5.5`](command.md) 安装。

## 运行 Laravel 队列(Queue)

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan queue:work --tries=3
```

## 运行 Laravel 调度器(Schedule)

使用系统级的计划任务（systemd、crontab,etc）执行以下命令即可

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan schedule:run
```
