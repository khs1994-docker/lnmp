# NGINX 日志

```bash
error_log  /var/log/nginx/error.log warn;

access_log  /var/log/nginx/access.log  main;
```

日志都能输出到 **标准输出** 或 **标准错误输出**，之后使用日志收集软件进行处理。
