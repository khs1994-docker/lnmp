# MANMP

```bash
$ cd lnmp/macos

$ ln -s $PWD/lnmp-mnamp.sh /usr/local/bin/
```

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

## 使用脚本管理软件

```bash
lnmp-mnamp.sh start | restart | stop SOFT_NAME

lnmp-mnamp.sh start | restart | stop all
```
