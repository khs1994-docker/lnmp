# nginx HTTPS

## 申请 SSL 证书

第一种方法是自行到国内云服务商等处申请 SSL 证书。

你也可以使用以下命令申请（由 [acme.sh](https://github.com/Neilpang/acme.sh) 提供技术支持，感谢 [Let's Encrypt](https://letsencrypt.org/)）。

## 通配符证书

Let's Encrypt 现已支持通过 DNS 验证来申请通配符证书，本例以通配符证书为例。

## 确定域名的 DNS 服务商

在 https://github.com/Neilpang/acme.sh/tree/master/dnsapi 找到自己域名的 DNS 服务商代码，例如

* `dnspod.cn` 代码为 `dns_dp`

* `GoDaddy.com` 代码为 `dns_gd`

...

## 修改 .env 文件

根据 DNS 服务商的不同，自行设置在 `.env` 文件设置相关变量

* dnspod.cn

  ```bash
  # [DNSPOD]
  DNS_TYPE=dns_dp

  DP_Id=
  DP_Key=
  ```

* GoDaddy.com

  ```bash
  # DNS 服务商
  DNS_TYPE=dns_gd

  GD_Key=sdf...
  GD_Secret=sdf...
  ```

...

### 申请网站证书

除了 `acme.sh` 原始参数外，支持以下参数

* `--httpd`

* `--rsa`

```bash
$ ./lnmp-docker.sh ssl example.com -d *.example.com -d t.example.com -d *.t.example.com [--debug]
```

> 特别提示，`*.example.com` 的证书不支持 `example.com` 所以一个主域要写两次

> 特别提示，第一个网址不用加 `-d` 参数，后面的需要加 `-d` 参数

若你的网站服务器不是 NGINX 而是 HTTPD，那么请加上 `--httpd` 参数，即

```bash
$ ./lnmp-docker.sh ssl example.com -d *.example.com --httpd
```

默认申请 `ECC` 证书，你可以加上 `--rsa` 来申请 RSA 证书，即

```bash
$ ./lnmp-docker.sh ssl example.com -d *.example.com --rsa
```

### 生成证书的位置

`./lnmp/config/nginx/ssl/*`

## 配置 nginx

nginx 主配置文件位于 `./config/etc/nginx/nginx.conf` （一般情况无需修改）。

子配置文件位于 `./config/nginx/*.conf`

主要注意的是 [文件路径](path.md) 问题。下面以 `https` 配置为例进行讲解。

```nginx
# https://github.com/khs1994-website/nginx-https

server {
  listen      80;

  # 域名

  server_name www.t.khs1994.com;
  return 301  https://$host$request_uri;
}

server{
  listen                     443 ssl http2;

  # 域名

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
  ssl_protocols              TLSv1.2; # TLSv1.3;

  # TLSv1.3
  # ssl_ciphers              TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-256-GCM-SHA384:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;

  ssl_ciphers                'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';

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

## 其他

### 签发自签名证书

```bash
$ ./lnmp-docker.sh ssl-self khs1994.com *.khs1994.com 127.0.0.1 localhost
```

生成的 ssl 文件位于 `./config/nginx/ssl-self`。

务必在浏览器导入根证书（`./config/nginx/ssl-self/root-ca.crt`）。

> `https://*.t.khs1994.com` 均指向 `127.0.0.1` 你可以使用这个网址测试 `https`。

## 示例配置

请查看 `./config/nginx/demo-*.conf`

## 第三方工具

* https://zerossl.com/

## TLSv1.3

[原生支持 TLSv1.3](https://github.com/khs1994-website/tls-1.3).

# More Information

* https://letsencrypt.org/docs/client-options/

* https://github.com/khs1994-website/server-side-tls

* https://github.com/khs1994-docker/tls
