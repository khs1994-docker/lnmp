# Registry 用户登录

```bash
$ docker run --rm \
      --entrypoint htpasswd \
      registry \
      # 部分 nginx 可能不能解密，你可以替换为下面的命令
      # -mbn username password > auth/nginx.htpasswd \
      -Bbn username password > auth/docker_registry.htpasswd
```
