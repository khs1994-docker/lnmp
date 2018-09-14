# MySQL 日志

```bash
log_output = FILE

log-error=/var/log/mysql/error.log

slow_query_log = 1

slow-query-log-file=/var/lib/mysql/host_name-slow.log
```

**错误日志** 能输出到 **标准输出**，之后使用日志收集软件进行处理。

~~**慢日志** 不能输出到 **标准错误输出**，方案是采用节点 hostPath /var/log/mysql/slow.APP_ENV.log~~

**慢日志** 放到数据库所在目录（系统默认）
