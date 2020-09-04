```bash
.
├── composer
│   ├── auth.example.json
│   └── config.example.json
├── crontabs
│   ├── README.md
│   └── root.example
├── default.sh
├── docker-compose.yml
├── etc
│   ├── buildkit
│   │   ├── buildkitd.default.toml
│   │   └── buildkitd.toml
│   ├── default
│   │   ├── apache2
│   │   │   └── httpd.conf
│   │   └── nginx
│   │       ├── conf.d
│   │       │   └── default.conf
│   │       └── nginx.conf
│   ├── docker
│   │   ├── daemon.json
│   │   ├── daemon.production.json
│   │   └── runtime.json
│   ├── hosts
│   ├── httpd
│   │   ├── httpd.conf
│   │   └── httpd.production.conf
│   ├── nginx
│   │   ├── fastcgi.conf
│   │   ├── nginx.conf
│   │   └── nginx.production.conf
│   └── supervisord.conf
├── frpc.ini
├── httpd
│   ├── demo-ajax-header.config
│   ├── demo-https.config
│   ├── demo-laravel.config
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── t.khs1994.com.crt
│   │   └── t.khs1994.com.key
│   ├── demo-vhost.conf
│   └── README.md
├── mariadb
│   ├── default
│   │   └── etc
│   │       └── mysql
│   │           ├── conf.d
│   │           │   └── docker.cnf
│   │           ├── debian.cnf
│   │           ├── debian-start
│   │           ├── mariadb.cnf
│   │           ├── mariadb.conf.d
│   │           │   ├── 50-client.cnf
│   │           │   ├── 50-mysql-clients.cnf
│   │           │   ├── 50-mysqld_safe.cnf
│   │           │   ├── 50-server.cnf
│   │           │   └── 60-galera.cnf
│   │           └── my.cnf -> mariadb.cnf
│   ├── docker.cnf
│   └── docker.production.cnf
├── mongodb
│   ├── mongod.conf
│   └── mongod.production.conf
├── mysql
│   ├── default
│   │   └── etc
│   │       └── mysql
│   │           ├── conf.d
│   │           │   ├── docker.cnf
│   │           │   └── mysql.cnf
│   │           ├── my.cnf
│   │           └── my.cnf.fallback
│   ├── docker.cnf
│   └── docker.production.cnf
├── nginx
│   ├── auth
│   │   └── README.md
│   ├── demo-ajax-header.config
│   ├── demo.config
│   │   ├── docker.mirror.config
│   │   ├── gitlab.config
│   │   ├── gzip.config
│   │   ├── http3.config
│   │   ├── phpmyadmin.config
│   │   ├── ppm.config
│   │   ├── unit-laravel.config
│   │   └── unit-proxy.config
│   ├── demo-fzjh-80.config
│   ├── demo-fzjh.config
│   ├── demo-include-php.config
│   ├── demo-include-ssl-common.config
│   ├── demo-include-ssl.config
│   ├── demo-linuxkit.config
│   ├── demo-registry.config
│   ├── demo-satis.conf
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── t.khs1994.com.crt
│   │   └── t.khs1994.com.key
│   ├── demo-ssl.config
│   ├── demo-toolkit-docs.conf
│   ├── demo-www.conf
│   ├── demo-www.config
│   ├── fzjh.conf
│   ├── gogs.config
│   ├── minio.config
│   ├── README.md
│   ├── ssl-self
│   └── wait-for-php.sh
├── nginx-unit
│   ├── demo-php.json
│   ├── full.json
│   ├── laravel.json.back
│   └── README.md
├── npm
├── path.md
├── php
│   ├── default
│   │   └── usr
│   │       └── local
│   │           └── etc
│   │               ├── php
│   │               │   ├── conf.d
│   │               │   │   ├── docker-php-ext-sodium.ini
│   │               │   │   ├── docker-php-ext-zip.ini
│   │               │   │   ├── php-ext-bcmath.ini
│   │               │   │   ├── php-ext-bz2.ini
│   │               │   │   ├── php-ext-calendar.ini
│   │               │   │   ├── php-ext-enchant.ini
│   │               │   │   ├── php-ext-exif.ini
│   │               │   │   ├── php-ext-ffi.ini
│   │               │   │   ├── php-ext-gd.ini
│   │               │   │   ├── php-ext-gettext.ini
│   │               │   │   ├── php-ext-gmp.ini
│   │               │   │   ├── php-ext-igbinary.ini
│   │               │   │   ├── php-ext-imap.ini
│   │               │   │   ├── php-ext-intl.ini
│   │               │   │   ├── php-ext-memcached.ini
│   │               │   │   ├── php-ext-mysqli.ini
│   │               │   │   ├── php-ext-opcache.ini
│   │               │   │   ├── php-ext-pcntl.ini
│   │               │   │   ├── php-ext-pdo_mysql.ini
│   │               │   │   ├── php-ext-pdo_pgsql.ini
│   │               │   │   ├── php-ext-pgsql.ini
│   │               │   │   ├── php-ext-redis.ini
│   │               │   │   ├── php-ext-shmop.ini
│   │               │   │   ├── php-ext-sockets.ini
│   │               │   │   ├── php-ext-sysvmsg.ini
│   │               │   │   ├── php-ext-sysvsem.ini
│   │               │   │   ├── php-ext-sysvshm.ini
│   │               │   │   ├── php-ext-tideways_xhprof.ini.default
│   │               │   │   ├── php-ext-xdebug.ini.default
│   │               │   │   └── php-ext-zstd.ini
│   │               │   ├── php.ini-development
│   │               │   └── php.ini-production
│   │               ├── php-fpm.conf
│   │               ├── php-fpm.conf.default
│   │               └── php-fpm.d
│   │                   ├── docker.conf
│   │                   ├── www.conf
│   │                   ├── www.conf.default
│   │                   └── zz-docker.conf
│   ├── docker-php.ini.example
│   ├── php.development.ini
│   ├── php.production.ini
│   ├── zz-docker.conf
│   └── zz-docker.production.conf
├── php8
│   ├── default
│   │   └── usr
│   │       └── local
│   │           └── etc
│   │               ├── php
│   │               │   ├── conf.d
│   │               │   │   ├── docker-php-ext-sodium.ini
│   │               │   │   ├── docker-php-ext-zip.ini
│   │               │   │   ├── php-ext-bcmath.ini
│   │               │   │   ├── php-ext-bz2.ini
│   │               │   │   ├── php-ext-calendar.ini
│   │               │   │   ├── php-ext-enchant.ini
│   │               │   │   ├── php-ext-exif.ini
│   │               │   │   ├── php-ext-ffi.ini
│   │               │   │   ├── php-ext-gd.ini
│   │               │   │   ├── php-ext-gettext.ini
│   │               │   │   ├── php-ext-gmp.ini
│   │               │   │   ├── php-ext-igbinary.ini
│   │               │   │   ├── php-ext-imap.ini
│   │               │   │   ├── php-ext-intl.ini
│   │               │   │   ├── php-ext-memcached.ini
│   │               │   │   ├── php-ext-mongodb.ini
│   │               │   │   ├── php-ext-mysqli.ini
│   │               │   │   ├── php-ext-opcache.ini
│   │               │   │   ├── php-ext-pcntl.ini
│   │               │   │   ├── php-ext-pdo_mysql.ini
│   │               │   │   ├── php-ext-pdo_pgsql.ini
│   │               │   │   ├── php-ext-pgsql.ini
│   │               │   │   ├── php-ext-redis.ini
│   │               │   │   ├── php-ext-shmop.ini
│   │               │   │   ├── php-ext-sockets.ini
│   │               │   │   ├── php-ext-sysvmsg.ini
│   │               │   │   ├── php-ext-sysvsem.ini
│   │               │   │   ├── php-ext-sysvshm.ini
│   │               │   │   ├── php-ext-tideways_xhprof.ini.default
│   │               │   │   ├── php-ext-xdebug.ini.default
│   │               │   │   ├── php-ext-yaml.ini
│   │               │   │   └── php-ext-zstd.ini
│   │               │   ├── php.ini-development
│   │               │   └── php.ini-production
│   │               ├── php-fpm.conf
│   │               ├── php-fpm.conf.default
│   │               └── php-fpm.d
│   │                   ├── docker.conf
│   │                   ├── www.conf
│   │                   ├── www.conf.default
│   │                   └── zz-docker.conf
│   ├── docker-php.ini.example
│   ├── php.development.ini
│   ├── php.production.ini
│   ├── zz-docker.conf
│   └── zz-docker.production.conf
├── python
├── README.md
├── redis
│   ├── redis.conf
│   └── redis.production.conf
├── registry
│   ├── ca.crt
│   ├── config.example.yml
│   ├── config.full.yml
│   ├── config.gcr.io.yml
│   ├── config.production.yml
│   ├── gcr.io.crt
│   ├── gcr.io.key
│   ├── kustomization.yaml
│   └── nginx.htpasswd.demo
├── s6
│   ├── README.md
│   └── services.d
│       ├── crond
│       │   └── run
│       ├── laravel-horizon
│       │   ├── log
│       │   │   └── run
│       │   └── run
│       ├── laravel-queue
│       │   └── run
│       └── php-fpm
│           ├── finish
│           └── run
├── s6-overlay
│   ├── fix-attrs.d
│   │   └── 01-mysql-data-dir
│   └── README.md
├── supervisord
│   └── supervisord.ini.example
└── yarn

62 directories, 195 files
```
