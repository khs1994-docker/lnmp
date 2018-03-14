```bash
.
├── README.md
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
│   ├── README.md
│   ├── demo-https.conf
│   ├── demo-laravel.conf
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
│   ├── demo-tls.conf
│   ├── demo-vhost.conf
│   ├── khs194.com.one.production.config
│   └── khs1940.com.one.development.config
├── mariadb
│   ├── conf.d
│   │   ├── docker.cnf
│   │   └── mysqld_safe_syslog.cnf
│   ├── conf.production.d
│   │   ├── docker.cnf
│   │   └── mysqld_safe_syslog.cnf
│   └── default
│       └── etc
│           └── mysql
│               ├── conf.d
│               │   ├── docker.cnf
│               │   └── mysqld_safe_syslog.cnf
│               ├── debian-start
│               ├── debian.cnf
│               ├── mariadb.cnf
│               ├── mariadb.conf.d
│               └── my.cnf
├── mongodb
│   ├── mongod.conf
│   └── mongod.production.conf
├── mysql
│   ├── conf.d
│   │   └── docker.cnf
│   ├── conf.production.d
│   │   └── docker.cnf
│   ├── default
│   │   └── etc
│   │       └── mysql
│   │           ├── conf.d
│   │           │   └── docker.cnf
│   │           └── my.cnf
│   └── my.cnf
├── nginx
│   ├── README.md
│   ├── auth
│   │   ├── README.md
│   │   └── docker_registry.htpasswd
│   ├── demo-laravel.conf
│   ├── demo-php.conf
│   ├── demo-registry.conf.backup
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
│   ├── demo-ssl.config
│   ├── demo-wechat-mini.config
│   ├── khs1994.com.one.development.config
│   ├── khs1994.com.one.production.config
│   ├── linuxkit.config
│   ├── registry.conf.backup
│   ├── ssl
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
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
│   │               │       ├── docker-php-ext-memcached.ini
│   │               │       ├── docker-php-ext-mongodb.ini
│   │               │       ├── docker-php-ext-opcache.ini
│   │               │       ├── docker-php-ext-pdo_mysql.ini
│   │               │       ├── docker-php-ext-pdo_pgsql.ini
│   │               │       ├── docker-php-ext-redis.ini
│   │               │       ├── docker-php-ext-xdebug.ini.default
│   │               │       ├── docker-php-ext-zip.ini
│   │               │       └── memory-limit.ini
│   │               ├── php-fpm.conf
│   │               ├── php-fpm.conf.default
│   │               └── php-fpm.d
│   │                   ├── docker.conf
│   │                   ├── www.conf
│   │                   ├── www.conf.default
│   │                   └── zz-docker.conf
│   ├── php
│   │   └── conf.d
│   │       ├── error-log.ini
│   │       └── xdebug.ini
│   ├── php-fpm.d
│   │   └── zz-docker.conf
│   ├── php-fpm.production.d
│   │   └── zz-docker.conf
│   ├── php.development.ini
│   └── php.production.ini
├── redis
│   ├── redis.conf
│   └── redis.production.conf
├── registry
│   ├── config.production.yml
│   └── config.yml
└── update.sh

44 directories, 88 files
```
