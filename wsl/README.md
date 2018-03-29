# Use WSL As PHP Development Environment

* https://www.khs1994.com/php/development/wsl.html

安装软件请查看上面的链接，为方便修改，文件夹内的配置文件均为示例 `*.example`,使用时请去掉 `.example` 后缀。

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

$ sudo ln -sf $WSL_HOME/lnmp/wsl/php.fpm.zz-wsl.conf /usr/local/php/etc/php-fpm.d/zz-wsl.conf

$ sudo cp -f $WSL_HOME/lnmp/wsl/mysql.wsl.cnf /etc/mysql/conf.d/wsl.cnf
```

## MySQL 远程登陆

可能会遇到不能从除了 `localhost` 的地址登陆的问题，请查看以下链接解决。

* https://www.khs1994.com/database/mysql/remote.html

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
