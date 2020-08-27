# 私有仓库登录密码

执行以下命令

```
$ docker run --rm --entrypoint htpasswd \
    httpd:alpine -mbn username password > nginx.htpasswd
```
