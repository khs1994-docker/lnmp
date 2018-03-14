# Use WSL As PHP Development Environment

* https://www.khs1994.com/php/development/wsl.html

安装软件请查看上面的链接

为方便修改，文件夹内的配置文件均为示例 `*.example`,使用时请去掉 `.example` 后缀,请 [参照这里](path.md)。

**注意备份原来的配置文件**

## 特别注意 NGINX

`/etc/nginx/nginx.conf` 主配置文件必须添加下面的配置项，否则 PHP 页面打开非常缓慢

```nginx
http {
  ...

  fastcgi_buffering off;

  ...
}
```

## APP_ENV

```bash
$ vi ~/.bash_profile

export APP_ENV=wsl
```

## 建立文件链接

```bash
# 设置 WSL_HOME 变量为 /mnt/c/Users/90621 注意替换为自己的实际路径
#
# 本例假设将 LNMP 放到了用户主目录

$ sudo ln -sf $WSL_HOME/lnmp/windows/wsl/nginx/conf.d /etc/nginx/conf.d

$ sudo ln -sf $WSL_HOME/lnmp/windows/wsl/php/zz-wsl.conf /usr/local/php/etc/php-fpm.d/zz-wsl.conf

$ sudo cp -f $WSL_HOME/lnmp/windows/wsl/mysql/wsl.cnf /etc/mysql/conf.d/wsl.cnf

$ sudo ln -sf $WSL_HOME/lnmp/windows/wsl/redis/redis.conf /etc/redis/redis.conf
```

## MySQL 远程登陆

可能会遇到不能从除了 `localhost` 的地址登陆的问题，请查看以下链接解决。

* https://www.khs1994.com/database/mysql/remote.html

## 快捷启动脚本

> 必须用下面的脚本来控制软件的 启动、重启、停止

将 `$WSL_HOME/lnmp/windows` 加入 `WSL` 环境变量 `PATH`

之后使用

```bash
$ lnmp-wsl.sh start | restart | stop [SOFT_NAME or all]
```
