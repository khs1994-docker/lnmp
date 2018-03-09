# MANMP

## 配置环境变量 `APP_ENV`

让 `Laravel` 加载 `.env.macos` 文件

### bash

```bash
$ vi ~/.bash_profile

export APP_ENV=macos
```

### fish

```bash
$ vi .config/fish/config.fish

set -x APP_ENV macos
```

### 验证

```bash
$ php artisan env

Current application environment: macos
```

## 安装

```bash
$ brew install mysql

$ brew install nginx

$ brew install php

# 安装 PHP 扩展

$ pecl channel-update pecl.php.net

$ pecl install redis memcached xdebug igbinary yaml

# 注意调整 php.ini 中的扩展路径

$ brew install composer

$ brew install redis

$ brew install memcached

$ brew install mongodb

$ brew install postgresql
```

## 配置 `php.ini`

> 务必按以下步骤配置扩展文件夹路径，近来 brew 已将 PHP 从 tap 移到了核心仓库。

```bash
# 获取 pecl 安装扩展地址

$ pecl config-get ext_dir

/usr/local/lib/php/pecl/20170718

# 修改 php.ini

extension_dir = "/usr/local/lib/php/pecl/20170718"
```

> pecl 安装扩展时会自动在 php.ini 文件开头添加扩展

## 配置 `PHP-FPM`

新建 `/usr/local/etc/php/7.2/php-fpm.d/zz-macos.conf` 文件，注意替换版本号

```bash
; 以后配置 PHP-FPM 均在此文件中，在这里重写，避免修改原文件

[global]

error_log = /usr/local/var/log/php-fpm.error.log

[www]

access.format = "%R - %u %t \"%m %r\" %s"
access.log = /usr/local/var/log/php-fpm.access.log

; user = root
; group = root

request_slowlog_timeout = 5

slowlog = /usr/local/var/log/php-fpm.slow.log

env[APP_ENV]=macos
```

## 使用脚本管理软件

```bash
$ cd lnmp/macos

$ ln -s $PWD/lnmp-mnamp.sh /usr/local/bin/

$ lnmp-mnamp.sh start | restart | stop SOFT_NAME

$ lnmp-mnamp.sh start | restart | stop all
```
