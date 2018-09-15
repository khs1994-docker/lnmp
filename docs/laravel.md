# 本项目开发 Laravel 最佳实践

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

请查看 [这里](command.md)

## Laravel 版本问题

由于本项目的 PHP 镜像内置的是 Laravel 安装器，而安装器只能安装最新版本 `5.7.x`。

所以如果你想要安装 `5.5.x` LTS 版本请使用 [`lnmp-laravel5.5`](command.md) 安装。

## 运行 Laravel 队列(Queue)

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan queue:work --tries=3
```

生产环境中使用系统级的守护程序（systemd）来保证上边的命令运行。具体请查看 [systemd](systemd.md)

## 运行 Laravel 调度器(Schedule)

使用系统级的计划任务（systemd、crontab,etc）执行以下命令即可

```bash
$ lnmp-docker php7-cli php /app/laravel/artisan schedule:run
```
