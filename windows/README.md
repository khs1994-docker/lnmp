# WNMP 环境搭建

由于 Windows 10 Docker 不太稳定，这里记录一下 Plan B WNMP 开发环境。

为了在任意目录执行命令，请设置系统环境变量 `PATH`，这里不再赘述。

环境 Widows 10，终端 [PowerShell Core 6.0](https://github.com/PowerShell/PowerShell/releases)，系统自带的 PowerShell 也行。

# MySQL

https://dev.mysql.com/downloads/mysql/

这里下载的是 zip 版，需要以管理员权限运行 PowerShell 执行一些命令完成初始化。（不建议使用 8.0.x 版本）

```bash
# 这条命令会产生一个随机密码，--initialize-insecure 初始化默认密码为空（不建议使用，后边会出现设置不了密码的情况）

$ mysqld --initialize

$ mysqld --install

# 启动服务

$ net start mysql

$ mysql -uroot -p

# 初始化密码在 data 目录打开其中 “计算机名.err”的文件

2018-02-12T02:48:05.597927Z 5 [Note] [MY-010454] A temporary password is generated for root@localhost: VgcYZ=Myf4N.

# 输入这个临时密码 VgcYZ=Myf4N. 登陆成功

# 修改密码，mytest 改为自己的密码，其他的原样输入。

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

复制 `php.ini`

```bash
$ php -v
```

## 启动

### RunHiddenConsole.zip

默认的直接运行 `php-cgi.exe` 会占用窗口，这里使用 RunHiddenConsole 可以后台运行。

http://blogbuildingu.com/files/RunHiddenConsole.zip

```bash
$ RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c C:/php/php.ini
```

## pecl 下载配置扩展

## php.ini

```bash
cgi.fix_pathinfo = 1
```

# Nginx

http://nginx.org/en/download.html

```bash
# 必须在 nginx 安装目录执行
$ start nginx

$ nginx -s stop
```

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

# PowerShell 脚本

为了方便的管理 WNMP，这里有一个脚本 `./windows/wnmp.ps1` ，使用之前在该文件开头修改好软件路径

```bash
$ ./windows/wnmp.ps1 start | stop | restart | status | ps
```

也可以将 `C:\Users\90621\lnmp\windows\wnmp.ps1` 加入 PATH,在任意目录执行 `wnmp.ps1 command`

# More Information

* http://www.jb51.net/article/107752.htm

* http://blog.csdn.net/nzing/article/details/7617558
