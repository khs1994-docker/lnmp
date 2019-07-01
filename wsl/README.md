# WSL As PHP Development Environment

* 可选版本 `Ubuntu 16.04` `Debian`

* 建议使用 `Debian` 版本，在商店搜索 `Linux` 选择 `Debian` 安装即可

* **NGINX** **PHP** 均为编译安装，配置目录为 `/usr/local/etc/*`。本项目提供了一键编译脚本，可以很方便的进行一键编译安装

* 编译安装软件请查看 https://blog.khs1994.com/php/development/wsl.html

## 设置环境变量

部分设置项可能与 `windows/README.md` 重复，保证设置过即可，建议操作之前先大概明白每条指令的意义！

**Windows PATH 变量会默认传递到 WSL**

打开 PowerShell

```bash
$ wsl --set-default-version 2

$ [environment]::SetEnvironmentvariable("LNMP_PATH", "$env:HOME/lnmp", "User");

$ [environment]::SetEnvironmentvariable("Path", "$env:Path;$env:LNMP_PATH\windows;$env:LNMP_PATH\wsl", "User")
```

```bash
$ sudo vi /etc/profile

# 在文件末尾添加如下内容
export WSL_HOME=/c/Users/90621 # 注意替换为自己的实际路径
export APP_ENV=wsl

$ vi ~/.bash_profile

export APP_ENV=wsl
```

## 脚本安装软件

也可以使用脚本（**脚本** 从 Docker 复制编译好的软件 [PHP 最新版] 到 WSL ，或设置 apt 从软件源 [或笔者打包的 deb 包] 安装）。

* https://hub.docker.com/r/khs1994/wsl/tags

```bash
$ lnmp-wsl-install # 输出帮助信息

$ lnmp-wsl-install php | mysql ...
```

### PHP

* PHP 版本问题：https://github.com/khs1994-docker/lnmp/issues/348

* PHP 多版本共存

主版本所有执行文件放到 `/usr/local/bin`，其他版本请使用绝对路径，例如 `/usr/local/php56/bin/php`。

```bash
$ lnmp-wsl-install enable php73 php72 | php71 | php70 | php56
```

#### PHP 安装路径

* `/usr/local/phpXX`
* `/usr/local/etc/phpXX`
* `/var/log/phpXX`

## NGINX

NGINX 需要自己编译安装 `$ lnmp-wsl-builder-nginx.py 1.17.0 ROOT_PASSWORD`

`/usr/local/etc/nginx/nginx.conf` 主配置文件必须添加下面的配置项，否则 PHP 页面打开非常缓慢

```nginx
http {
  ...

  fastcgi_buffering off;

  ...
}
```

## 建立文件链接

**本例假设将 khs1994-docker/lnmp 放到了用户家目录**

为了方便配置，NGINX 的子配置文件目录在本项目 `wsl/nginx` 文件夹中，之后在 WSL 中通过 **软链接** 链接到软件配置目录。所以你要配置 WSL 中的 NGINX，直接在 Windows 编辑本项目文件夹内的 `wsl/nginx/*.conf` 文件即可。

```bash
$ sudo ln -sf $WSL_HOME/lnmp/wsl/nginx/ /usr/local/etc/nginx/conf.d

$ sudo ln -sf $WSL_HOME/lnmp/wsl/config/php.fpm.zz-wsl.conf /usr/local/php73/etc/php-fpm.d/zz-wsl.conf

$ cat $WSL_HOME/lnmp/wsl/config/mysql.wsl.cnf | sudo tee /etc/mysql/conf.d/wsl.cnf
```

## MySQL

手动设置 `APT` 之后安装，不要直接使用 `apt install mysql-server`(直接安装的是 MariaDB)。

* https://dev.mysql.com/downloads/repo/apt/

密码在安装的时候弹出窗口中进行设置。

### MySQL 远程登陆

可能会遇到不能从除了 `localhost` 的地址登陆的问题，请查看以下链接解决。

* https://blog.khs1994.com/database/mysql/remote.html

Debian MySQL 初始化请查看：

* https://blog.khs1994.com/raspberry-pi3/mysql.html

## 启动脚本

> 必须用下面的脚本来控制软件的 启动、重启、停止

```bash
$ lnmp-wsl start | restart | stop [SOFT_NAME or all]
```

## Docker CLI

* https://blog.khs1994.com/docker/wsl-run-docker-cli.html

```bash
$ lnmp-wsl-docker-cli
```

## PHP 扩展列表

```bash
$ for ext in `ls`; do echo '*' $( php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
```

* [x] bcmath
* [x] bz2
* [x] calendar
* [ ] com_dotnet
* [x] ctype
* [x] curl
* [x] date
* [ ] dba
* [x] dom
* [x] enchant
* [x] exif
* [ ] ext_skel
* [ ] ext_skel_win32.php
* [x] fileinfo
* [x] filter
* [x] ftp
* [x] gd
* [x] gettext
* [x] gmp
* [x] hash
* [x] iconv
* [x] imap
* [ ] interbase
* [x] intl
* [x] json
* [x] ldap
* [x] libxml
* [x] mbstring
* [ ] mysqli
* [x] mysqlnd
* [ ] oci8
* [ ] odbc
* [x] opcache
* [x] openssl
* [x] pcntl
* [x] pcre
* [x] pdo
* [ ] pdo_dblib
* [ ] pdo_firebird
* [x] pdo_mysql
* [ ] pdo_oci
* [ ] pdo_odbc
* [x] pdo_pgsql
* [x] pdo_sqlite
* [ ] pgsql
* [x] phar
* [x] posix
* [x] pspell
* [x] readline
* [ ] recode
* [x] reflection
* [x] session
* [x] shmop
* [x] simplexml
* [ ] skeleton
* [ ] snmp
* [x] soap
* [x] sockets
* [x] sodium
* [x] spl
* [x] sqlite3
* [x] standard
* [x] sysvmsg
* [x] sysvsem
* [x] sysvshm
* [x] tidy
* [x] tokenizer
* [x] xml
* [x] xmlreader
* [x] xmlrpc
* [x] xmlwriter
* [x] xsl
* [ ] zend_test
* [x] zip
* [x] zlib
