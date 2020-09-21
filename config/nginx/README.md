# LNMP Docker 示例 nginx 配置文件

示例域名 `*.t.khs1994.com` (解析到 `127.0.0.1`)

* `t.khs1994.com` `www.t.khs1994.com`

* `laravel.t.khs1994.com`

查看示例项目时务必将 `./config/nginx/demo-ssl/root-ca.crt` 导入浏览器中。

若使用 `NGINX` 代理其他服务，当其他服务不可用后，请将配置文件改为 `*.config`，否则 `NGINX` 将无法启动。
