# Use WSL As PHP Development Environment

* 建议使用 `Debian` 版本，在商店搜索 `Debian` 安装即可。

* https://www.khs1994.com/php/development/wsl.html

编译安装软件请查看上面的链接，为方便修改，文件夹内的配置文件均为示例 `*.example`,使用时请去掉 `.example` 后缀。

**注意备份原来的配置文件**

## 设置环境变量

```bash
$ sudo vi /etc/profile

# 在文件末尾添加如下内容

export WSL_HOME=/mnt/c/Users/90621 # 注意替换为自己的实际路径

export PATH=$WSL_HOME/lnmp/wsl:$PATH

export APP_ENV=wsl

# 保存

$ vi ~/.bash_profile

# 两个文件必须都设置 APP_ENV

export APP_ENV=wsl
```

## 脚本安装

```bash
$ lnmp-wsl-install.sh nginx | php | mysql ...
```

## 特别注意 NGINX

`/etc/nginx/nginx.conf` 主配置文件必须添加下面的配置项，否则 PHP 页面打开非常缓慢

```nginx
http {
  ...

  fastcgi_buffering off;

  ...
}
```

## 建立文件链接

**本例假设将 LNMP 放到了用户主目录**

```bash
$ sudo ln -sf $WSL_HOME/lnmp/wsl/nginx/ /etc/nginx/conf.d

$ sudo ln -sf $WSL_HOME/lnmp/wsl/php.fpm.zz-wsl.conf /usr/local/php72/etc/php-fpm.d/zz-wsl.conf

$ sudo cp -f $WSL_HOME/lnmp/wsl/mysql.wsl.cnf /etc/mysql/conf.d/wsl.cnf
```

## MySQL 远程登陆

可能会遇到不能从除了 `localhost` 的地址登陆的问题，请查看以下链接解决。

* https://www.khs1994.com/database/mysql/remote.html

Debian MySQL 初始化请查看：

* https://www.khs1994.com/raspberry-pi3/mysql.html

## 快捷启动脚本

> 必须用下面的脚本来控制软件的 启动、重启、停止

```bash
$ lnmp-wsl.sh start | restart | stop [SOFT_NAME or all]
```

## WSL Run Docker CLI

* https://www.khs1994.com/docker/wsl-run-docker-cli.html

```bash
$ sh $WSL_HOME/lnmp/wsl/lnmp-docker-cli.sh
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
* [ ] enchant
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
* [ ] ldap
* [x] libxml
* [x] mbstring
* [ ] mysqli
* [x] mysqlnd
* [ ] oci8
* [ ] odbc
* [ ] opcache
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
* [ ] pspell
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
* [ ] sysvmsg
* [x] sysvsem
* [ ] sysvshm
* [x] tidy
* [x] tokenizer
* [ ] wddx
* [x] xml
* [x] xmlreader
* [x] xmlrpc
* [x] xmlwriter
* [x] xsl
* [ ] zend_test
* [x] zip
* [x] zlib
