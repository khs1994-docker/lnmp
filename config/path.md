```bash
.
├── composer
│   ├── config.example.json
│   └── config.json
├── default.sh
├── docker-compose.yml
├── etc
│   ├── default
│   │   ├── apache2
│   │   │   └── httpd.conf
│   │   └── nginx
│   │       ├── conf.d
│   │       │   └── default.conf
│   │       └── nginx.conf
│   ├── docker
│   │   ├── daemon.json
│   │   └── daemon.production.json
│   ├── httpd
│   │   ├── httpd.conf
│   │   └── httpd.production.conf
│   ├── nginx
│   │   ├── fastcgi.conf
│   │   ├── nginx.conf
│   │   └── nginx.production.conf
│   └── supervisord.conf
├── httpd
│   ├── demo-ajax-header.config
│   ├── demo-https.config
│   ├── demo-laravel.config
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
│   ├── demo-vhost.conf
│   └── README.md
├── mariadb
│   ├── default
│   │   └── etc
│   │       └── mysql
│   │           ├── conf.d
│   │           │   ├── docker.cnf
│   │           │   └── mysqld_safe_syslog.cnf
│   │           ├── debian.cnf
│   │           ├── debian-start
│   │           ├── mariadb.cnf
│   │           ├── mariadb.conf.d
│   │           └── my.cnf
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
│   ├── demo-fzjh-80.config
│   ├── demo-fzjh.config
│   ├── demo-gitlab.config
│   ├── demo-include-php.config
│   ├── demo-include-ssl-common.config
│   ├── demo-include-ssl.config
│   ├── demo-khsci.config
│   ├── demo-linuxkit.config
│   ├── demo-nginx-unit.config
│   ├── demo-registry.config
│   ├── demo-satis.conf
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
│   ├── demo-ssl.config
│   ├── demo-toolkit-docs.conf
│   ├── demo-wechat-mini.config
│   ├── demo-www.conf
│   ├── demo-www.config
│   ├── fzjh.conf
│   ├── gogs.config
│   ├── minio.conf
│   ├── minio.config
│   ├── README.md
│   ├── ssl
│   │   ├── t.khs1994.com.crt
│   │   └── t.khs1994.com.key
│   ├── ssl-self
│   ├── unit.config
│   ├── wait-for-php.sh
│   └── www.t.khs1994.com.conf
├── nginx-unit
│   ├── demo-php.json
│   ├── full.json
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
│   │               │   │   ├── docker-php-ext-bcmath.ini
│   │               │   │   ├── docker-php-ext-bz2.ini
│   │               │   │   ├── docker-php-ext-calendar.ini
│   │               │   │   ├── docker-php-ext-enchant.ini
│   │               │   │   ├── docker-php-ext-exif.ini
│   │               │   │   ├── docker-php-ext-gd.ini
│   │               │   │   ├── docker-php-ext-gettext.ini
│   │               │   │   ├── docker-php-ext-gmp.ini
│   │               │   │   ├── docker-php-ext-igbinary.ini
│   │               │   │   ├── docker-php-ext-imap.ini
│   │               │   │   ├── docker-php-ext-intl.ini
│   │               │   │   ├── docker-php-ext-memcached.ini
│   │               │   │   ├── docker-php-ext-mongodb.ini
│   │               │   │   ├── docker-php-ext-mysqli.ini
│   │               │   │   ├── docker-php-ext-opcache.ini
│   │               │   │   ├── docker-php-ext-pcntl.ini
│   │               │   │   ├── docker-php-ext-pdo_mysql.ini
│   │               │   │   ├── docker-php-ext-pdo_pgsql.ini
│   │               │   │   ├── docker-php-ext-pgsql.ini
│   │               │   │   ├── docker-php-ext-redis.ini
│   │               │   │   ├── docker-php-ext-sockets.ini
│   │               │   │   ├── docker-php-ext-sodium.ini
│   │               │   │   ├── docker-php-ext-swoole.ini
│   │               │   │   ├── docker-php-ext-sysvmsg.ini
│   │               │   │   ├── docker-php-ext-sysvsem.ini
│   │               │   │   ├── docker-php-ext-sysvshm.ini
│   │               │   │   ├── docker-php-ext-xdebug.ini.default
│   │               │   │   ├── docker-php-ext-xmlrpc.ini
│   │               │   │   ├── docker-php-ext-xsl.ini
│   │               │   │   ├── docker-php-ext-yaml.ini
│   │               │   │   └── docker-php-ext-zip.ini
│   │               │   ├── php.ini-development
│   │               │   └── php.ini-production
│   │               ├── php-fpm.conf
│   │               ├── php-fpm.conf.default
│   │               └── php-fpm.d
│   │                   ├── docker.conf
│   │                   ├── www.conf
│   │                   ├── www.conf.default
│   │                   └── zz-docker.conf
│   ├── docker-php.ini
│   ├── docker-xdebug.ini
│   ├── php.development.ini
│   ├── php.production.ini
│   ├── zz-docker.conf
│   ├── zz-docker-log.conf
│   ├── zz-docker-pm.conf
│   ├── zz-docker.production.conf
│   └── zz-docker-slow-log.conf
├── python
├── README.md
├── redis
│   ├── redis.conf
│   └── redis.production.conf
├── registry
│   ├── ca.crt
│   ├── config.gcr.io.yml
│   ├── config.production.yml
│   ├── config.yml
│   ├── gcr.io.crt
│   └── gcr.io.key
└── supervisord
    ├── supervisord.ini
    └── supervisord.ini.example

42 directories, 133 files
```
