# Dockerfile 注意事项

**后续步骤指定了 ENTRYPOINT，则 CMD 变为空**

```docker
FROM nginx:alpine

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
```

此时 `CMD` 为空，即生成的镜像不会继承 `nginx:alpine` 的 `CMD`。
