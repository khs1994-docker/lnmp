```bash
.
├── README.md
├── composer
│   ├── auth.example.json
│   └── config.example.json
├── crontabs
│   ├── README.md
│   └── root.example
├── default.sh
├── docker-compose.yml
├── etc
│   ├── apt
│   │   ├── sources.list.debian
│   │   └── sources.list.debian.wsl
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
│   ├── README.md
│   ├── demo-ajax-header.config
│   ├── demo-https.config
│   ├── demo-laravel.config
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── t.khs1994.com.crt
│   │   └── t.khs1994.com.key
│   └── demo-vhost.conf
├── mariadb
│   ├── conf.d
│   │   └── docker.cnf
│   ├── default
│   │   └── etc
│   │       └── mysql
│   │           ├── conf.d
│   │           ├── debian-start
│   │           ├── debian.cnf
│   │           ├── mariadb.cnf
│   │           ├── mariadb.conf.d
│   │           │   ├── 05-skipcache.cnf
│   │           │   ├── 50-client.cnf
│   │           │   ├── 50-mysql-clients.cnf
│   │           │   ├── 50-server.cnf
│   │           │   ├── 60-galera.cnf
│   │           │   └── 99-enable-encryption.cnf.preset
│   │           │       └── enable_encryption.preset
│   │           └── my.cnf -> /etc/alternatives/my.cnf
│   ├── docker.cnf
│   └── docker.production.cnf
├── mongodb
│   ├── mongod.conf
│   └── mongod.production.conf
├── mysql
│   ├── conf.d
│   │   └── docker.cnf
│   ├── default
│   │   └── etc
│   │       ├── my.cnf
│   │       └── mysql
│   │           └── conf.d
│   ├── docker.cnf
│   └── docker.production.cnf
├── nginx
│   ├── README.md
│   ├── auth
│   │   └── README.md
│   ├── demo-ajax-header.config
│   ├── demo-include-php.config
│   ├── demo-include-ssl-common.config
│   ├── demo-include-ssl.config
│   ├── demo-satis.conf
│   ├── demo-ssl
│   │   ├── root-ca.crt
│   │   ├── t.khs1994.com.crt
│   │   └── t.khs1994.com.key
│   ├── demo-ssl.config
│   ├── demo-www.conf
│   ├── demo.config
│   │   ├── docker-registry.config
│   │   ├── docker.mirror.config
│   │   ├── fzjh-80.config
│   │   ├── fzjh.config
│   │   ├── gitlab.config
│   │   ├── gogs.config
│   │   ├── gzip.config
│   │   ├── http3.config
│   │   ├── laravel.config
│   │   ├── linuxkit.config
│   │   ├── minio.config
│   │   ├── phpmyadmin.config
│   │   ├── ppm.config
│   │   ├── unit-laravel.config
│   │   └── unit-proxy.config
│   ├── ssl-self
│   └── wait-for-php.sh
├── nginx-unit
│   ├── README.md
│   ├── demo-php.json
│   ├── full.json
│   └── laravel.json.back
├── npm
├── path.md
├── php
│   ├── README.md
│   ├── default
│   │   └── usr
│   │       └── local
│   │           └── etc
│   │               ├── php
│   │               │   ├── conf.d
│   │               │   │   ├── docker-fpm.ini
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
│   ├── docker-php.example.ini
│   ├── php-PHP_SAPI.ini
│   ├── php-cli.example.ini
│   ├── php.development.ini
│   ├── php.production.ini
│   ├── zz-docker.example.conf
│   └── zz-docker.production.conf
├── php8
│   ├── README.md
│   ├── default
│   │   └── usr
│   │       └── local
│   │           └── etc
│   │               ├── pear.conf
│   │               ├── php
│   │               │   ├── conf.d
│   │               │   │   ├── docker-fpm.ini
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
│   ├── docker-php.example.ini
│   ├── php-cli.example.ini
│   ├── php.development.ini
│   ├── php.production.ini
│   ├── zz-docker.example.conf
│   └── zz-docker.production.conf
├── python
├── redis
│   ├── redis.example.conf
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
│   ├── demo
│   │   ├── README.md
│   │   ├── cont-init.d
│   │   │   └── 01-contenv-example
│   │   ├── fix-attrs.d
│   │   │   ├── 01-mysql-data-dir
│   │   │   └── 02-mysql-log-dirs
│   │   ├── s6-overlay
│   │   │   ├── s6-rc.d
│   │   │   │   ├── README.md
│   │   │   │   ├── myapp
│   │   │   │   │   ├── finish
│   │   │   │   │   ├── producer-for
│   │   │   │   │   ├── run
│   │   │   │   │   └── type
│   │   │   │   ├── myapp-log
│   │   │   │   │   ├── consumer-for
│   │   │   │   │   ├── dependencies
│   │   │   │   │   ├── pipeline-name
│   │   │   │   │   ├── run
│   │   │   │   │   └── type
│   │   │   │   ├── myapp-log-prepare
│   │   │   │   │   ├── type
│   │   │   │   │   └── up
│   │   │   │   └── user
│   │   │   │       └── contents.d
│   │   │   │           └── myapp
│   │   │   └── scripts
│   │   │       └── myapp-log-prepare
│   │   └── services.d
│   │       └── myapp
│   │           ├── finish
│   │           ├── log
│   │           │   └── run
│   │           └── run
│   ├── s6-overlay
│   │   ├── s6-rc.d
│   │   │   ├── crond
│   │   │   │   ├── producer-for
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── crond-log
│   │   │   │   ├── consumer-for
│   │   │   │   ├── dependencies
│   │   │   │   ├── pipeline-name
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── laravel-horizon
│   │   │   │   ├── dependencies
│   │   │   │   ├── producer-for
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── laravel-horizon-log
│   │   │   │   ├── consumer-for
│   │   │   │   ├── dependencies
│   │   │   │   ├── pipeline-name
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── laravel-prepare
│   │   │   │   ├── type
│   │   │   │   └── up
│   │   │   ├── laravel-queue
│   │   │   │   ├── dependencies
│   │   │   │   ├── producer-for
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── laravel-queue-log
│   │   │   │   ├── consumer-for
│   │   │   │   ├── dependencies
│   │   │   │   ├── pipeline-name
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── php-fpm
│   │   │   │   ├── finish
│   │   │   │   ├── run
│   │   │   │   └── type
│   │   │   ├── user
│   │   │   │   ├── contents.d
│   │   │   │   │   ├── crond
│   │   │   │   │   ├── crond-log
│   │   │   │   │   ├── crond-pipeline
│   │   │   │   │   ├── laravel-horizon
│   │   │   │   │   ├── laravel-horizon-log
│   │   │   │   │   ├── laravel-horizon-pipeline
│   │   │   │   │   ├── laravel-queue
│   │   │   │   │   ├── laravel-queue-log
│   │   │   │   │   ├── laravel-queue-pipeline
│   │   │   │   │   └── php-fpm
│   │   │   │   └── type
│   │   │   └── user2
│   │   │       ├── contents.d
│   │   │       └── type
│   │   └── scripts
│   │       └── laravel-prepare
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
├── supervisord
│   └── supervisord.ini.example
└── yarn

93 directories, 265 files
```
