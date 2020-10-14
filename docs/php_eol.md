# 使用 EOL 的 PHP 版本

**1. 在 `docker-lnmp.include.yml` 文件中增加以下内容，具体请查看 [自定义](custom.md)**

```yaml
services:
  nginx:
    depends_on:
    - php5

  php5:
    << : *common
    restart: ${LNMP_RESTART:-always}
    env_file: ./cli/timezone.env
    # build:
    #   context: ./dockerfile/php/
    # 5.x 只支持 5.6.37 -- 5.6.40 其他版本请自行构建
    image: "khs1994/php:5.6.37-fpm-alpine"
    volumes:
      - ${APP_ROOT:-./app}:${LNMP_PHP_PATH:-/app}:cached
      # fpm config
      - ./config/php5/zz-docker.conf:/usr/local/etc/php-fpm.d/zz-docker.conf:ro,cached
      # php.ini
      - ./config/php5/${LNMP_PHP_INI:-php.development.ini}:/usr/local/etc/php/php.ini:ro,cached
      # php.ini override
      - ./config/php5/docker-php.ini:/usr/local/etc/php/conf.d/docker-php.ini:ro,cached
      # log,etc
      - ./log/php:/var/log/php:cached
      - ./log/supervisord.log:/var/log/supervisord.log:cached
      - ./log/supervisord:/var/log/supervisord:cached
      - type: volume
        source: zoneinfo-data
        target: /usr/share/zoneinfo
        volume:
          nocopy: false
    networks:
      - frontend
      - backend
    expose:
      - "9000"
    command: php-fpm -R -F
    # command: php-fpm -F
    environment:
      - LNMP_DOCKER_VERSION=${LNMP_DOCKER_VERSION:-v20.10} PHP_EOL VERSION
      - APP_ENV=development
      - LNMP_XDEBUG_REMOTE_HOST=${LNMP_XDEBUG_REMOTE_HOST:-192.168.199.100}
      - LNMP_XDEBUG_REMOTE_PORT=${LNMP_XDEBUG_REMOTE_PORT:-9003}
      - LNMP_OPCACHE_ENABLE=${LNMP_OPCACHE_ENABLE:-1}
```

**2. 编辑 `.env` 文件，在 `LNMP_SERVICES` 变量中增加软件名 `php5`**

```diff
- LNMP_SERVICES="nginx mysql php7 redis" # 默认配置

+ LNMP_SERVICES="nginx mysql php7 redis php5" # 增加 php5
```

**3. 新建 `config/php5` 文件夹**

参照 `config/php` 文件夹自行增加以下文件

* 1. `zz-docker.conf` PHP-FPM 子配置文件

```conf
[global]
daemonize = no
error_log = /var/log/php/php-fpm-error.log
[www]
listen = 9000

user = www-data
group = www-data

access.format = "%R - %u %t \"%m %r\" %s"
access.log = /var/log/php/php-fpm-access.log
```

* 2. `php.ini` PHP 主配置文件 [参考](https://github.com/php/php-src/blob/PHP-5.6/php.ini-development)

* 3. `docker-php.ini` PHP 子配置文件 (从 `config/php/docker-php.example.ini` 中复制)

提示：php7.1（包含）及以下版本 配置扩展必须加扩展名 `.so`

```diff
# 普通扩展
- extension=xxx
+ extension=xxx.so

# zend 扩展
- zend_extension=xdebug
+ zend_extension=xdebug.so
```

**4. 配置 nginx 使用 php5**

```conf
location ~ .*\.php(\/.*)*$ {
  # fastcgi_pass   php7:9000;
  fastcgi_pass   php5:9000;
  include        fastcgi.conf;
}
```

**5. 启动**

```bash
$ ./lnmp-docker up
```
