# nginx HTTPS

## 申请 SSL 证书

第一种方法是自行到国内云服务商等处申请 SSL 证书。

你也可以使用以下命令申请（由 [acme.sh](https://github.com/Neilpang/acme.sh) 提供技术支持，感谢 [Let's Encrypt](https://letsencrypt.org/)）。

>在使用之前，提前设置好 `dnspod.cn` api 相关变量

```bash
# [DNSPOD]

DP_ID=
DP_KEY=
```

```bash
$ ./lnmp-docker.sh ssl www.khs1994.com
```

其他 DNS 服务商请参照 `acme.sh` [支持文档](https://github.com/Neilpang/acme.sh/tree/master/dnsapi)，设置好相关变量之后，使用 `acme.sh` 原始命令申请 SSL 证书。

```bash
$ ./lnmp-docker.sh ssl acme.sh \
    --issue \
    --dns dns_gd \
    -d example.com \
    -d www.example.com
```

## 配置 nginx

nginx 主配置文件位于 `./config/etc/nginx/nginx.conf` （一般情况无需修改）。

子配置文件位于 `./config/nginx/*.conf`

主要注意的是 [文件路径](path.md) 问题。下面以 `https` 配置为例进行讲解。

```nginx

server{

  # 域名

  server_name demo.lnmp.khs1994.com;
  listen 443 ssl http2;

  # 「重要」 此处为容器内路径（注意不是本机路径）！ 本机 ./app/ 对应容器内 /app/

  root /app/blog/public;

  index index.html index.php;

  # 「重要」 ssl 证书路径，此处为容器内路径（注意不是本机路径）！
  # 本机 ./config/nginx/ 对应容器内 /etc/nginx/conf.d/

  ssl_certificate      conf.d/demo-ssl/demo.lnmp.khs1994.com.cer;
  ssl_certificate_key  conf.d/demo-ssl/demo.lnmp.khs1994.com.key;
  ssl_session_cache    shared:SSL:1m;
  ssl_session_timeout  5m;
  ssl_protocols        TLSv1.2;
  ssl_ciphers          'ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5';
  ssl_prefer_server_ciphers on;

  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }

  location ~ .*\.php(\/.*)*$ {

    # 「重要」 php7 为 docker-compose.yml 中定义的服务名
    # 同理在 PHP 文件中连接其他容器请使用 服务名，严禁尝试使用 127.0.0.1 localhost。

    fastcgi_pass   php7:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include        fastcgi_params;
  }
}
```

你也可以在 https://khs1994.gitee.io/server-side-tls/ssl-config-generator/ 便捷的生成 SSL 配置。

## 其他

### 签发自签名证书

```bash
$ ./lnmp-docker.sh ssl-self www.khs1994.com
```

生成的 ssl 文件位于 `config/nginx/ssl-self`。

## 第三方工具

* https://zerossl.com/

# More Information

* https://letsencrypt.org/docs/client-options/

* https://github.com/khs1994-website/server-side-tls

* https://github.com/khs1994-docker/tls
