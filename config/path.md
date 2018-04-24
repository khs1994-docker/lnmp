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
│   ├── demo-ajax-header.config
│   ├── demo-https.config
│   ├── demo-laravel.config
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── www.t.khs1994.com.crt
│   │   └── www.t.khs1994.com.key
│   └── demo-vhost.conf
├── mariadb
│   ├── default
│   │   └── etc
│   │       └── mysql
│   │           ├── conf.d
│   │           │   ├── docker.cnf
│   │           │   └── mysqld_safe_syslog.cnf
│   │           ├── debian-start
│   │           ├── debian.cnf
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
│   ├── README.md
│   ├── auth
│   │   └── README.md
│   ├── demo-ajax-header.config
│   ├── demo-fzjh-80.config
│   ├── demo-fzjh.config
│   ├── demo-include-php.config
│   ├── demo-include-ssl.config
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
│   ├── ssl
│   ├── ssl-self
│   └── wait-for-php.sh
├── nginx.my
│   ├── 301.conf
│   ├── 80.conf
│   ├── README.md
│   ├── auth
│   │   ├── README.md
│   │   └── nginx.htpasswd
│   ├── docker-registry.conf
│   ├── drone.conf
│   ├── gogs.conf
│   ├── nexus.conf.back
│   ├── php.conf
│   ├── php.config
│   ├── py-django.conf
│   ├── ssl
│   │   ├── docker.domain.com.crt
│   │   ├── docker.domain.com.key
│   │   ├── docker.t.khs1994.com.cer
│   │   ├── docker.t.khs1994.com.key
│   │   ├── drone.t.khs1994.com.cer
│   │   ├── drone.t.khs1994.com.key
│   │   ├── git.t.khs1994.com.crt
│   │   ├── git.t.khs1994.com.key
│   │   ├── khs1994.com.crt
│   │   └── khs1994.com.key
│   ├── ssl-self
│   │   ├── root-ca.crt
│   │   ├── t.khs1994.com.crt
│   │   └── t.khs1994.com.key
│   ├── ssl.config
│   └── t.khs1994.conf
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
├── redis
│   ├── redis.conf
│   └── redis.production.conf
└── registry
    ├── config.production.yml
    └── config.yml

41 directories, 114 files
```
