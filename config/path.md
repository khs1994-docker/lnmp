```bash
.
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
│   └── nginx
│       ├── fastcgi.conf
│       ├── nginx.conf
│       └── nginx.production.conf
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
│   │           │   └── docker.cnf
│   │           └── my.cnf
│   ├── docker.cnf
│   └── docker.production.cnf
├── nginx
│   ├── auth
│   │   └── README.md
│   ├── demo-ajax-header.config
│   ├── demo-fzjh-80.config
│   ├── demo-fzjh.config
│   ├── demo-include-php.config
│   ├── demo-include-ssl-common.config
│   ├── demo-include-ssl.config
│   ├── demo-khsci.config
│   ├── demo-linuxkit.config
│   ├── demo-registry.config
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
│   ├── demo-ssl.config
│   ├── demo-wechat-mini.config
│   ├── demo-www.conf
│   ├── demo-www.config
│   ├── fzjh.conf
│   ├── khsci.conf
│   ├── README.md
│   ├── ssl
│   │   ├── ci.crt
│   │   ├── home.khs1994.com.crt
│   │   ├── home.khs1994.com.key
│   │   └── www.khs1994.com.crt
│   ├── ssl-self
│   └── wait-for-php.sh
├── path.md
├── php
│   ├── default
│   │   └── usr
│   │       └── local
│   │           └── etc
│   │               ├── php
│   │               │   └── conf.d
│   │               │       ├── date_timezone.ini
│   │               │       ├── docker-php-ext-bcmath.ini
│   │               │       ├── docker-php-ext-gd.ini
│   │               │       ├── docker-php-ext-igbinary.ini
│   │               │       ├── docker-php-ext-memcached.ini
│   │               │       ├── docker-php-ext-mongodb.ini
│   │               │       ├── docker-php-ext-opcache.ini
│   │               │       ├── docker-php-ext-pcntl.ini
│   │               │       ├── docker-php-ext-pdo_mysql.ini
│   │               │       ├── docker-php-ext-pdo_pgsql.ini
│   │               │       ├── docker-php-ext-redis.ini
│   │               │       ├── docker-php-ext-sodium.ini
│   │               │       ├── docker-php-ext-swoole.ini
│   │               │       ├── docker-php-ext-xdebug.ini.default
│   │               │       ├── docker-php-ext-yaml.ini
│   │               │       ├── docker-php-ext-zip.ini
│   │               │       └── memory-limit.ini
│   │               ├── php-fpm.conf
│   │               ├── php-fpm.conf.default
│   │               └── php-fpm.d
│   │                   ├── docker.conf
│   │                   ├── www.conf
│   │                   ├── www.conf.default
│   │                   └── zz-docker.conf
│   ├── docker-error-log.ini
│   ├── docker-xdebug.ini
│   ├── php.development.ini
│   ├── php.production.ini
│   ├── zz-docker.conf
│   └── zz-docker.production.conf
├── README.md
├── redis
│   ├── redis.conf
│   └── redis.production.conf
└── registry
    ├── config.production.yml
    └── config.yml

37 directories, 94 files
```
