# Kong

* https://github.com/Kong/kong

## 数据库迁移

在 `.env` 文件中启用 `postgresql-kong` `kong`

第一步先执行数据库迁移

在 `docker-compose.include.yml` 中将 `kong` 字段的 `command` 指令取消注释。

由于 `postgresql` 初始化需要一定的时间，所以等待一会，重启失败的 `kong` 即可。

## 启动

`command` 指令注释掉，启动 kong

## 配置

## UI

`.env` 加入 `kong-dashboard`

Web 地址 `host:8082`

## 参考

* https://blog.csdn.net/tangsl388/article/details/82851505
