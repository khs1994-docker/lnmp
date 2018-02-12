# WNMP 环境搭建

由于 `Docker For Windows` 不太稳定，这里记录一下 Plan B WNMP 开发环境。

为了在任意目录执行命令，请设置系统环境变量 `PATH`，这里不再赘述。

环境 `Windows 10`，终端 [PowerShell Core 6.0](https://github.com/PowerShell/PowerShell/releases)，系统自带的 `PowerShell` 也行。

我将软件都放在了 C 盘根目录，即 `C:\nginx-1.13.8` `C:\php` `C:\mysql` ...

# MySQL

https://dev.mysql.com/downloads/mysql/

这里下载的是 `zip` 版，需要以管理员权限运行 `PowerShell` 执行一些命令完成初始化。（不建议使用 8.0.x 版本）

```bash
# 这条命令会产生一个随机密码，--initialize-insecure 初始化默认密码为空（不建议使用，后边会出现设置不了密码的情况）

$ mysqld --initialize

$ mysqld --install

# 启动服务

$ net start mysql

$ mysql -uroot -p

# 初始密码在 data 目录打开其中 "计算机名.err" 的文件

[Note] [MY-010454] A temporary password is generated for root@localhost: VgcYZ=Myf4N.

# 输入这个临时密码 VgcYZ=Myf4N. 登陆成功

# 修改密码，将 mytest 改为自己的密码，其他的原样输入

$ ALTER USER 'root'@'localhost' IDENTIFIED BY 'mytest';

# 否则会报错

ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.

# 刷新

$ FLUSH PRIVILEGES;

# 新增 root 用户远程登陆权限

$ GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mytest' WITH GRANT OPTION;
```

## 停止服务

```bash
$ net stop mysql
```

# PHP

http://windows.php.net/download/

里面有 `Non Thread Safe` 和 `Thread Safe`，两者区别请查阅资料，我这里的是下载 `NTS` 版。

只有 `TS` 版才包含 `php7apache2_4.dll` （配置 apache 可能会用到，我后边 apache 没有选择那种方式，这里记录一下）

## 复制 `php.ini`

## 查看版本信息

```bash
$ php -v
```

## 启动

### RunHiddenConsole.zip

默认的直接运行 `php-cgi.exe` 会占用窗口，这里使用 `RunHiddenConsole` 可以后台运行。

http://blogbuildingu.com/files/RunHiddenConsole.zip

```bash
$ RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c C:/php/php.ini
```

## pecl 下载配置扩展

注意与 PHP 版本对应。

## php.ini

```bash
extension_dir = "C:/php/ext"

# 开启扩展，自行取消注释

date.timezone = PRC


cgi.fix_pathinfo = 1
```

# Nginx

http://nginx.org/en/download.html

```bash
# 必须在 nginx 安装目录执行
$ start nginx

$ nginx -s stop
```

## 修改配置

不再赘述

## Composer

https://getcomposer.org/Composer-Setup.exe

```bash
$ composer -V
```

# Redis

WSL

```bash
$ sudo apt install redis-server

$ sudo redis-server /etc/redis/redis.conf
```

# MongoDB

WSL

```bash
$ sudo apt install mongodb-server

$ mkdir -p /data/db

$ chmod 777 /data/db

# 后台运行
$ sudo mongod --fork --logpath=/var/run/mongodb/error.log
```

# Memcached

WSL

[`memcached`](http://pecl.php.net/package/memcached) 扩展暂不支持 Windows。

```bash
$ sudo apt install memcached

$ memcached -d
```

# Apache

我一般用的 `nginx`，这里简单记录一下 `apache`。

PHP 在 Windows Apache 下的几种运行模式 [官方文档](http://php.net/manual/fa/install.windows.apache2.php) 讲的很清楚了（暂无中文翻译），我这里是 `fcgid.so` 方式，其他 `php7_module` 等方式请自行查阅资料。

在 [文中](http://httpd.apache.org/docs/current/platform/windows.html) 提到的前两个地方选择一个下载，后几个是集成安装包。

我在 https://www.apachehaus.com/cgi-bin/download.plx 下载，记得同时下载 `Mod FCGID 2.3.9a for Apache 2.4.x` 模块，注意版本对应。

```bash
# 进入安装目录 bin 目录
# 安装为系统服务

$ httpd.exe -k install
```

将 bin 目录中的 `ApacheMonitor.exe` 拖到桌面，可以完成 httpd 服务的启动等操作。

## fcgid 模块

解压下载后的模块文件夹将 `modules\mod_fcgid.so` 移入 apache 安装目录的 `modules` 文件夹中。

将 `conf/extra/httpd-fcgid.conf` 移入 apache 安装目录的 `conf/extra` 文件夹中，并修改 php 路径。

## http.conf

```bash
Define SRVROOT "C:/apache24"

# 需要启用哪些模块自己去掉注释
LoadModule rewrite_module modules/mod_rewrite.so
# 这里引入 fcgid 模块
LoadModule fcgid_module modules/mod_fcgid.so

DirectoryIndex index.php index.html index.htm

# Virtual hosts
# 打开虚拟主机配置，以后多域名均在子配置文件中设置，避免修改 httpd.conf
Include conf/extra/httpd-vhosts.conf

Include conf/extra/httpd-fcgid.conf
```

## httpd-vhosts.conf

```bash
<VirtualHost *:80>
    DocumentRoot "C:/Users/90621/lnmp/app/laravel/public"
    ServerName 127.0.0.1
    ServerAlias 127.0.0.1
    ErrorLog "C:/logs/apache/127.0.0.1.err"
    CustomLog "C:/logs/apache/127.0.0.1.access" combined

    <Directory "C:/Users/90621/lnmp/app/laravel/public" >
      AddHandler fcgid-script .php
      Options Indexes FollowSymLinks ExecCGI
    	FcgidWrapper "C:/php/php-cgi.exe" .php
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
    </Directory>
</VirtualHost>
```

测试配置

```bash
$ httpd -t
```

之后使用 `ApacheMonitor.exe` 启动服务。

# PowerShell 脚本

为了方便的管理 `WNMP`，这里有一个脚本 `./windows/wnmp.ps1` ，使用之前在该文件开头修改好软件路径

```bash
$ ./windows/wnmp.ps1 start | stop | restart | status | ps
```

也可以将 `C:\Users\90621\lnmp\windows\wnmp.ps1` 加入 `PATH`,在任意目录执行 `wnmp.ps1 command`

# More Information

* http://www.jb51.net/article/107752.htm

* http://blog.csdn.net/nzing/article/details/7617558

* https://www.cnblogs.com/52fhy/p/6059685.html
