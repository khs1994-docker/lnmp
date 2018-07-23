# NGINX HTTPS 配置文件

NGINX 主配置文件位于 `./config/etc/nginx/nginx.conf` （一般情况无需修改）。

子配置文件位于 `./config/nginx/*.conf`

主要注意的是 [文件路径](path.md) 问题。下面以 `https` 配置为例进行讲解。

```nginx
# https://github.com/khs1994-website/nginx-https

server {
  listen      80;
  server_name www.t.khs1994.com;

  return 301  https://$host$request_uri;
}

server{
  listen                     443 ssl http2;
  server_name                www.t.khs1994.com;

  # 「重要」 此处为容器内路径（注意不是本机路径）！ 本机 ./app/ 对应容器内 /app/

  root                       /app/demo;
  index                      index.html index.htm index.php;

  # RSA & ECC 双证书

  # 「重要」 ssl 证书路径，此处为容器内路径（注意不是本机路径）！
  # 本机 ./config/nginx/ 对应容器内 /etc/nginx/conf.d/

  ssl_certificate            conf.d/demo-ssl/www.t.khs1994.com.crt;
  ssl_certificate_key        conf.d/demo-ssl/www.t.khs1994.com.key;

  ssl_certificate            conf.d/demo-ssl/www.t.khs1994.com.crt;
  ssl_certificate_key        conf.d/demo-ssl/www.t.khs1994.com.key;

  ssl_session_cache          shared:SSL:1m;
  ssl_session_timeout        5m;
  ssl_protocols              TLSv1.2 TLSv1.3;

  # TLSv1.3
  ssl_ciphers                'TLS13+AESGCM+AES128:TLS13+AESGCM+AES256:TLS13+CHACHA20:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';

  ssl_prefer_server_ciphers  on;

  ssl_stapling on;
  ssl_stapling_verify on;

  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }

  location ~ /.php$ {

    # 「重要」 php7 为 docker-compose.yml 中定义的服务名
    # 同理在 PHP 文件中连接其他容器请使用 服务名，严禁尝试使用 127.0.0.1 localhost。

    fastcgi_pass   php7:9000;
    include        fastcgi.conf;
  }
}
```

你也可以在 https://khs1994.gitee.io/server-side-tls/ssl-config-generator/ 便捷的生成 SSL 配置。
