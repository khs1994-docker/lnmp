# WNAMP 环境搭建

* [问题反馈](https://github.com/khs1994-docker/lnmp/issues/474)

* 系统 `Windows 10`

* 终端 [PowerShell Core 7.0](https://github.com/PowerShell/PowerShell/releases)，系统自带的 `PowerShell` 也可以。

* 部分软件放在了 C 盘根目录，即 `C:\nginx` `C:\php` `C:\mysql` `C:\Apache24`

* 部分软件使用 `WSL` 来安装运行(例如 `Redis`)。

## 快速初始化 WNAMP 环境

> 使用以下脚本，开发者可以快速的建立开发环境，后续会介绍脚本所做的工作。

```bash
$ lnmp-windows-pm.ps1 install nginx mysql php composer node
```

### 安装指定软件(Windows 包管理)

```bash
$ lnmp-windows-pm.ps1 install xxx [--pre 安装测试版软件]

# $ lnmp-windows-pm.ps1 install go
```

## 使用 PS1 脚本控制 `WNAMP`

为了方便的管理 `WNAMP`，你可以使用本项目 windows 目录下的脚本 `lnmp-wnamp.ps1`

**使用之前** 在 `.env.ps1` 文件中参照 `.env.example.ps1` 设置好相关变量

```bash
$ lnmp-wnamp.ps1 start | stop | restart | status | ps [SOFT_NAME] [SOFT_NAME_2]
```

## 系统环境变量说明

* 将各软件路径加入系统环境变量 `PATH`

* 新增变量 `APP_ENV` 值为 `windows`, 之后 `Laravel` 框架就会默认的加载 `.env.windows` 文件。

打开 `PowerShell` 执行以下命令设置环境变量

```bash
$ [environment]::SetEnvironmentvariable("LNMP_PATH", "$HOME\lnmp", "User")

$ [environment]::SetEnvironmentvariable("Path", "$env:Path;c:\php;c:\mysql\bin;c:\nginx;c:\Apache24\bin", "User")

$ [environment]::SetEnvironmentvariable("APP_ENV", "windows", "User")
```

**退出 PowerShell，重新打开，若以下命令不生效的话请注销之后再登录**

```bash
$ cd LARAVEL_APP_PATH

$ php artisan env

Current application environment: windows

# 输出 windows 说明设置成功
```

## vclib

部分软件（例如：MySQL）依赖 `vclib`，请首先安装，请查看 `windows/lnmp-windows-pm-repo/vclib`

## MySQL

https://dev.mysql.com/downloads/mysql/

这里下载的是 `zip` 版，需要以管理员权限运行 `PowerShell` 执行一些命令完成初始化。

8.0.4-rc+ ，默认使用新的密码验证机制 `caching_sha2_password` ，目前主流的客户端不支持该方式，所以我们仍然采用旧的密码验证机制。

在 `C` 盘根目录增加 `my.cnf` 文件，文件内容可以参考本目录下的 `config/my.cnf`.

```bash
# 这条命令会产生一个随机密码，--initialize-insecure 初始化默认密码为空
$ mysqld --initialize

# 安装服务
$ mysqld --install

# 启动服务
$ net start mysql

$ mysql -uroot -p

# 初始密码在 mysql 安装目录（C:\mysql） data/${env:COMPUTERNAME}.err 的文件，或者使用以下命令查看密码

$ select-string "A temporary password is generated for" C:\mysql\data\${env:COMPUTERNAME}.err

[Note] [MY-010454] A temporary password is generated for root@localhost: VgcYZ=Myf4N.

# 输入这个临时密码 VgcYZ=Myf4N. 登陆成功

# 修改密码，将 mytest 改为自己的密码，其他的原样输入

$ ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mytest';

# 必须执行上一步修改临时密码，否则会报错

ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.

# 刷新

$ FLUSH PRIVILEGES;

# 新增 root 用户远程登陆权限

# $ GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mytest' WITH GRANT OPTION;
# 8.0.11 报错，原因相关功能已废弃

$ CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'mytest' ;

$ GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
```

**停止服务**

```bash
$ net stop mysql
```

## PHP

https://windows.php.net/download/

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

其他启动方式，请在最上方 `问题反馈` 中的链接查看

### pecl 手动下载扩展(或者使用 pickle)

手动在 https://pecl.php.net/ 下载扩展（注意与 PHP 版本对应）。

之后在 `php.ini` 中增加配置(为了后续升级方便将 pecl 下载的扩展放到 `C:\php-ext`)。

```bash
extension=C:\php-ext\php_yaml

zend_extension=C:\php-ext\php_xdebug
```

* 或者使用 [pickle](https://github.com/khs1994-php/pickle)

## Composer

https://getcomposer.org/Composer-Setup.exe

```bash
$ composer -V
```

## Nginx

https://nginx.org/en/download.html

```bash
$ nginx -p C:/nginx -t

$ nginx -p C:/nginx

$ nginx -p C:/nginx -s stop
```

### 修改配置

官方文档：https://www.nginx.com/resources/wiki/start/topics/examples/phpfastcgionwindows/

## Apache

**FastCGI**

其他通过在配置文件中加载模块 `LoadModule php5_module "c:/php/php7apache2_4.dll"` 即 `Installing as an Apache handler` 等运行模式（网上资料较多）请自行查阅资料。

在 [文中](https://httpd.apache.org/docs/current/platform/windows.html) 提到的前两个地方选择一个下载，后几个是集成安装包。

在 https://www.apachelounge.com/download/ 下载

同时下载 `mod_fcgid` 模块，注意版本（`win64` `VS16`）对应 (可能不太好找，网页搜索 `mod_fcgid` 来定位)。

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

**首次安装，必须先安装服务。**

```bash
$ httpd -k install

# $ httpd -k uninstall
```

**测试配置文件通过之后，启动服务。**

```bash
$ httpd -t

$ httpd -d C:/Apache24 -k start

# $ httpd -d C:/Apache24 -k stop
```

### https

* https://blog.khs1994.com/php/development/apache/config.html

* https://github.com/khs1994-website/server-side-tls

请查看示例配置。

## WSL

> 存在 WSL 打开 PHP 页面缓慢的问题，解决办法请查看下方的文章

Plan C `WSL` 请查看 [WSL 快速搭建 LNMP 环境](https://github.com/khs1994-docker/lnmp/tree/master/wsl)。

## 使用 lnmp-wsl 脚本控制 WSL 软件

由于部分软件运行于 WSL ,你可以使用本项目 `wsl` 目录下的 `lnmp-wsl` 脚本控制它们。

打开 PowerShell

```bash
$ wsl -- wslpath "'$HOME'"

/mnt/c/Users/90621 # 记住这个值，此值与下方 WSL_HOME 的设置值对应

$ sudo vi /etc/profile

export WSL_HOME=/mnt/c/Users/90621 # 与上方值对应

# 再次提示 Windows Path 变量会传递到 WSL 的 PATH 变量，所以我们只需在 Windows 设置即可。

# 保存重新登录
```

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

[php `memcached` 扩展](https://pecl.php.net/package/memcached) 暂不支持 Windows。

```bash
$ sudo apt install memcached

$ memcached -d
```

## More Information

* https://www.jb51.net/article/107752.htm

* https://blog.csdn.net/nzing/article/details/7617558

* https://www.cnblogs.com/52fhy/p/6059685.html

* https://www.cnblogs.com/chuxuezhe/archive/2012/08/29/2661656.html

* https://www.iteye.com/blog/nbczw8750-2353989
