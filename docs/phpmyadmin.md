# phpMyAdmin

`.env` 增加 `phpmyadmin`

```diff
- LNMP_SERVICES="nginx mysql php7 redis"
+ LNMP_SERVICES="nginx mysql php7 redis phpmyadmin"
```

默认的使用 `phpmyadmin:latest` 镜像体积很大，可以用 `phpmyadmin:fpm-alpine` 配合 `nginx` 来使用

```bash
phpmyadmin                   fpm-alpine                     acaf66e70db5        2 days ago          141MB
phpmyadmin                   latest                         e8e3976e7f7f        2 days ago          469MB
```

```yaml
# docker-lnmp.include.yml

services:
  phpmyadmin:
    image: phpmyadmin:5.1.0-fpm-alpine
    volumes:
      - phpmyadmin:/var/www/html

  nginx:
    volumes:
      - phpmyadmin:/var/www/html

volumes:
  phpmyadmin:
```

将 `config/nginx/demo.config/phpmyadmin.config` 复制到 `config/nginx/phpmyadmin.conf`，自行调整配置后，重启 NGINX 容器。
