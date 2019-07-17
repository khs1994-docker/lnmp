# Kong

* https://konghq.com/install/

## 初始化

```bash
$ lnmp-docker run kong-migrations
```

## 端口

* `8000` on which Kong listens for incoming HTTP traffic from your clients, and forwards it to your upstream services.

* `8443` on which Kong listens for incoming HTTPS traffic. This port has a similar behavior as the :8000 port, except that it expects HTTPS traffic only. This port can be disabled via the configuration file.

* `8001` on which the Admin API used to configure Kong listens.
* `8444` on which the Admin API listens for HTTPS traffic.
