# nginx HTTPS

nginx 主配置文件位于 `./config/etc/nginx/nginx.conf`，子配置文件位于 `./config/nginx/`

主要注意的是 `[文件路径](path.md)` 问题。下面以 `https` 配置为例进行讲解。

```nginx
server{

  # 域名

  server_name lnmp-docker-laravel-blog-dev.khs1994.com;
  listen 443 ssl http2;

  # 「重要」 此处为容器内路径（注意不是本机路径）！ 本机 ./app/ 对应容器内 /app/

  root /app/blog/public;

  index index.html index.php;

  # 「重要」 ssl 证书路径，此处为容器内路径（注意不是本机路径）！ 本机 ./config/nginx/ 对应容器内 /etc/nginx/conf.d/

  ssl_certificate conf.d/ssl-demo/lnmp-docker-laravel-blog-dev.khs1994.com.cer;
  ssl_certificate_key conf.d/ssl-demo/lnmp-docker-laravel-blog-dev.khs1994.com.key;
  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5';
  ssl_prefer_server_ciphers on;

  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }

  location ~ .*\.php(\/.*)*$ {

    # 「重要」 php7 为 docker-compose.yml 中定义的服务名，同理在 PHP 文件中连接其他容器请使用 服务名，慎用 127.0.0.1 localhost。

    fastcgi_pass php7:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
  }
}
``
