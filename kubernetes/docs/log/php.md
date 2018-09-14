# PHP 日志

```bash
error_log= /var/log/php-fpm/php.error.log
```

**PHP 错误日志** 和 **xdebug 日志** 不能输出到 **标准错误输出** ,方案是输出到节点 hostPath /var/log/php.error.log 之后由日志收集软件进行处理

## PHP-FPM

```bash
[global]

error_log = /var/log/php-fpm/error.log

[www]

access.log = /var/log/php-fpm/access.log

request_slowlog_timeout = 5

slowlog = /var/log/php-fpm/slow.log
```

**访问日志** 和 **慢日志** 输出到 **标准错误输出**，之后通过日志收集软件进行处理。
