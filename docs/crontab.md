# Crontab 计划任务

## 编辑配置文件

```bash
$ cd scripts/crontab

# 只能写入到 root 文件中，其他文件不可以

$ vi root

# 这里以 Laravel 配置计划任务为例

* * * * * php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1
```

## 重启 PHP 容器

```bash
$ ./lnmp-docker.sh restart php7
```
