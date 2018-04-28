# Windows

## FastCGI

* https://github.com/khs1994-docker/lnmp/issues/474

```nginx
upstream fastcgi_php {
  server 127.0.0.1:9000;
  server 127.0.0.1:9100;
  server 127.0.0.1:9200;
  server 127.0.0.1:9300;
  server 127.0.0.1:9400;
  server 127.0.0.1:9500;
}

server {
  ...

  location ~ .*\.php(\/.*)*$ {
    # fastcgi_pass 127.0.0.1:9000;

    fastcgi_pass   fastcgi_php;
    include        fastcgi.conf;
  }

  ...
}
```
