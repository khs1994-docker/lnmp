# NGINX Unit

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## WSL 编译安装 NGINX Unit

* [官方文档](https://unit.nginx.org/)

```bash
# 克隆源码
$ git clone --depth=1 https://github.com/nginx/unit

$ cd unit

$ ./configure --prefix=/usr/local/nginx_unit --openssl

# PHP 编译选项必须额外增加 --enable-embed=shared 选项，本文使用 $ lnmp-wsl-install php 7.2.5 命令所安装 PHP

$ ./configure php \
      --module=php73 \
      --lib-path=/usr/local/php73/lib \
      --config=/usr/local/php73/bin/php-config

      # --lib-static

$ make

$ sudo make install

$ cd /usr/local/nginx_unit

$ sudo ./sbin/unitd
```

## 配置

* http://unit.nginx.org/configuration/#php-application
* http://unit.nginx.org/howto/wordpress/
* https://www.nginx.com/blog/installing-wordpress-with-nginx-unit

### TLS (1.4 + support)

$ cat cert.pem ca.pem key.pem > bundle.pem

$ curl -X PUT --data-binary @bundle.pem 127.1:8443/certificates/cert_name

通过向 Linux Socket 发送 json 文件来配置 Unit

```json
{
    "listeners": {
        "*:8300": {
            "application": "test",
            "tls": {
              "certificate": "cert_name"
            }
        }
    },

    "applications": {
        "test": {
            "type": "php",
            "processes": 20,
            "root": "/app/demo/public",
            "index": "index.php",
            "user": "www-blogs",
            "group": "www-blogs",
            "options": {
                "file": "/etc/php.ini",
                "admin": {
                    "memory_limit": "256M",
                    "variables_order": "EGPCS",
                    "expose_php": "0"
                },
                "user": {
                  "display_errors": "0"
                }
            }
        }
    }
}
```

`root` 路径必须填绝对路径，将以上内容保存为 `start.json` 本文保存到 `/usr/local/nginx_unit/start.json`

```bash
$ cd /app/test

$ vi index.php

<?php

phpinfo();
```

### 新建配置

```bash
$ curl -X PUT -d @/usr/local/nginx_unit/start.json  \
       --unix-socket /usr/local/nginx_unit/control.unit.sock \
       http://localhost/config

# 浏览器打开 127.0.0.1:8300 看到 phpinfo 页面，完成部署
```

其他语言使用方法，或更多使用详情自行查看文档。

## 使用方法

一个应用监听一个端口。前端通过 NGINX 进行代理。

## 示例

### Laravel

请查看

* `config/nginx/demo.config/unit-laravel.config`
* `config/nginx-unit/laravel.json.back`
