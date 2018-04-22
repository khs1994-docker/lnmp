# WNAMP 环境搭建

由于 `Docker For Windows` 不太稳定，这里记录一下 Plan B `WNAMP` 开发环境。

环境 `Windows 10`，终端 [PowerShell Core 6.0](https://github.com/PowerShell/PowerShell/releases)，系统自带的 `PowerShell` 也行。

我将软件都放在了 C 盘根目录，即 `C:\nginx` `C:\php` `C:\mysql` ...

MySQL、Apache 设置为服务之后会开机自启动，在服务管理中将启动类型设为手动，避免开机自启。

**部分软件使用 `WSL` 来安装运行。**

## 系统环境变量说明

**务必知道 Windows Linux 环境变量的作用及设置方法，如果你不知道，就不用往下看了**

* 为了在任意目录执行命令，请将各软件路径加入系统环境变量 `PATH`

* **特别的** 新增变量 `APP_ENV` 值为 `windows`, 之后 `Laravel` 框架就会默认的加载 `.env.windows` 文件。

打开 `PowerShell` 执行以下命令设置环境变量

```bash
$ [environment]::SetEnvironmentvariable("LNMP_PATH", "$HOME\lnmp", "User");

$ [environment]::SetEnvironmentvariable("Path", "$env:Path;c:\php;c:\mysql\bin;c:\nginx;c:\apache24\bin", "User")

$ [environment]::SetEnvironmentvariable("APP_ENV", "windows", "User");
```

**退出，重新打开**

为了方便的管理 `WNAMP`，这里有一个脚本 `./windows/lnmp-wnamp.ps1` ，**使用之前** 在该文件开头修改好软件路径。

```bash
$ [environment]::SetEnvironmentvariable("Path", "$env:Path;$env:LNMP_PATH\windows;$env:LNMP_PATH\wsl", "User")

# 退出，重新打开

$ lnmp-wnamp.ps1 start | stop | restart | status | ps SOFT_NAME
```

注销之后重新登录

验证

```bash
$ cd LARAVEL_APP_PATH

$ php artisan env

Current application environment: windows
```

# wsl

> 存在 WSL 打开 PHP 页面缓慢的问题，解决办法请查看下方的文章

Plan C `WSL` 请查看 [WSL 快速搭建 LNMP 环境](https://github.com/khs1994-docker/lnmp/tree/master/wsl)。

## 安装 lnmp-wsl.sh 脚本

打开 PowerShell

```bash
$ cd $HOME

$ bash

$ pwd

/mnt/c/Users/90621 # 记住这个值，此值与下方 WSL_HOME 的设置值对应

$ sudo vi /etc/profile

export WSL_HOME=/mnt/c/Users/90621 # 与上方值对应

# 再次提示 Windows Path 变量会传递到 WSL 的 PATH 变量，所以我们只需在 Windows 设置即可。

# 保存重新登录
```

## MySQL

https://dev.mysql.com/downloads/mysql/

这里下载的是 `zip` 版，需要以管理员权限运行 `PowerShell` 执行一些命令完成初始化。

8.0.4-rc+ ，默认使用新的密码验证机制 `caching_sha2_password` ，目前主流的客户端不支持该方式，所以我们仍然采用旧的密码验证机制。

在 `C` 盘根目录增加 `my.cnf` 文件，文件内容可以参考本目录下的 `my.cnf.example`.

```bash
# 这条命令会产生一个随机密码，--initialize-insecure 初始化默认密码为空

$ mysqld --initialize

$ mysqld --install

# 启动服务

$ net start mysql

$ mysql -uroot -p

# 初始密码在 mysql 安装目录（C:\mysql） data/计算机名.err 的文件，或者使用以下命令查看密码

$ select-string "A temporary password is generated for" C:\mysql\data\*.err

[Note] [MY-010454] A temporary password is generated for root@localhost: VgcYZ=Myf4N.

# 输入这个临时密码 VgcYZ=Myf4N. 登陆成功

# 修改密码，将 mytest 改为自己的密码，其他的原样输入

$ ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mytest';

# 否则会报错

ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.

# 刷新

$ FLUSH PRIVILEGES;

# 新增 root 用户远程登陆权限

# $ GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mytest' WITH GRANT OPTION;
# 8.0.11 报错

$ CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'mytest' ;

$ GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
```

### 停止服务

```bash
$ net stop mysql
```

## PHP

http://windows.php.net/download/

里面有 `Non Thread Safe` 和 `Thread Safe`，两者区别请查阅资料，我这里的是下载 `NTS` 版。

只有 `TS` 版才包含 `php7apache2_4.dll` （php 以 apache 模块方式运行才会用到，我后边 apache 选择的是 fcgi 方式，这里记录一下）

### 复制 `php.ini`

```bash

; 开启扩展，自行取消注释

;extension=bz2
extension=curl

date.timezone = PRC

cgi.fix_pathinfo = 1
```

### 查看版本信息

```bash
$ php -v
```

### 启动

#### RunHiddenConsole.zip

默认的直接运行 `php-cgi.exe` 会占用窗口，这里使用 `RunHiddenConsole` 可以后台运行。

http://blogbuildingu.com/files/RunHiddenConsole.zip

```bash
$ RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c C:/php/php.ini
```

### pecl 下载扩展

手动在 http://pecl.php.net/ 下载扩展（注意与 PHP 版本对应）。

之后在 `php.ini` 中增加配置(为了后续升级方便将 pecl 下载的扩展放到 `C:\php-ext`)。

```bash
extension=C:\php-ext\php_yaml

zend_extension=C:\php-ext\php_xdebug
```

## Composer

https://getcomposer.org/Composer-Setup.exe

```bash
$ composer -V
```

## Nginx

http://nginx.org/en/download.html

```bash
$ nginx -p C:/nginx -t

$ nginx -p C:/nginx

$ nginx -p C:/nginx -s stop
```

### 修改配置

官方文档：https://www.nginx.com/resources/wiki/start/topics/examples/phpfastcgionwindows/

## Redis WSL

```bash
$ sudo apt install redis-server

$ sudo redis-server /etc/redis/redis.conf
```

## MongoDB WSL

```bash
$ sudo apt install mongodb-server

$ mkdir -p /data/db

$ chmod 777 /data/db

# 后台运行
$ sudo mongod --fork --logpath=/var/run/mongodb/error.log
```

## Memcached WSL

[`memcached`](http://pecl.php.net/package/memcached) 扩展暂不支持 Windows。

```bash
$ sudo apt install memcached

$ memcached -d
```

## Apache

我一般用的 `nginx`，这里记录一下 `apache`。

PHP 在 Windows Apache 下的几种运行模式 [官方文档](http://php.net/manual/fa/install.windows.apache2.php) 讲的很清楚了（暂无中文翻译）。

我这里是 `Running PHP under FastCGI` 方式

其他通过在配置文件中加载模块 `LoadModule php5_module "c:/php/php7apache2_4.dll"` 即 `Installing as an Apache handler` 等运行模式（网上资料较多）请自行查阅资料。

在 [文中](http://httpd.apache.org/docs/current/platform/windows.html) 提到的前两个地方选择一个下载，后几个是集成安装包。

我在 http://www.apachelounge.com/download/ 下载

同时下载 `mod_fcgid` 模块，注意版本（`win64` `vc15`）对应 (可能不太好找，网页搜索 `mod_fcgid` 来定位)。

### fcgid 模块

解压下载后的模块文件夹将 `mod_fcgid-2.3.9\mod_fcgid.so` 移入 Apache 安装目录( `C:\Apache24` )的 `modules` 文件夹中。

在 Apache 安装目录( `C:\Apache24` )的 `conf.d` 文件夹中新建 [`httpd-fcgid.conf`](config/apache-fcgi/httpd-fcgid.conf) 文件，文件内容从 github 本项目目录中获取，注意修改 php 路径。

### http.conf

* [示例配置](config/apache-fcgi)

```bash
ServerRoot "c:/Apache24"

# 需要启用哪些模块自己去掉注释
LoadModule headers_module modules/mod_headers.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
LoadModule ssl_module modules/mod_ssl.so

<IfModule dir_module>
    DirectoryIndex index.html index.php
</IfModule>

# 包含子配置文件夹，以后多域名均在子配置文件夹 C:/Apache24/conf.d 中设置，避免修改 httpd.conf

Include conf.d/*.conf
```

首次安装，必须先安装服务。

```bash
$ httpd -k install

# $ httpd -k uninstall
```

测试配置文件通过之后，启动服务。

```bash
$ httpd -t

$ httpd -d C:/Apache24 -k start

# $ httpd -d C:/Apache24 -k stop
```

### https

* https://www.khs1994.com/php/development/apache/config.html

* https://github.com/khs1994-website/server-side-tls

请查看示例配置。

## More Information

* http://www.jb51.net/article/107752.htm

* http://blog.csdn.net/nzing/article/details/7617558

* https://www.cnblogs.com/52fhy/p/6059685.html

* https://www.cnblogs.com/chuxuezhe/archive/2012/08/29/2661656.html

* http://nbczw8750.iteye.com/blog/2353989
