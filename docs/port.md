# 服务端口开放

默认只对公网开放 `80` `443` 端口。

若开放 `MySQL` 端口，请编辑 `.env` 文件

```bash
# LNMP_MYSQL_PORT=127.0.0.1:3306

LNMP_MYSQL_PORT=0.0.0.0:3306
```

其他软件同理，不再赘述。

## 自定义开放端口

编辑 `docker-compose.include.yml`, 增加服务条目。

> 例如 PHP 默认没有开放端口，我们想开放 `10001` 端口。

```bash
version: "3.7"

services:

  # open more port
  php7:
    ports:
      - "10001:10001"
```

> 编辑之后执行 `$ lnmp-docker config` 查看配置是否正确，之后启动即可。
