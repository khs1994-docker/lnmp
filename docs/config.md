# 软件配置

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

自定义软件配置是最重要的一项功能，为了方便本项目升级，严禁直接修改 `./config` 下的原始配置文件。

下面详细介绍如何正确的自定义配置。

## 原则

* 一般情况下使用默认配置即可，如果你需要修改某些配置，方便的话首先请在本项目 GitHub 提出 `issue`，提出优化配置的建议，之后按照本教程正确的自定义配置。

* 以追加(子配置文件 **重写** 主配置文件、后边的 **重写** 前边的)方式进行配置

* 尽量一个软件一个配置文件

## 总体步骤（三步）

**1.** 进入配置文件所在目录 `./config/SOFT_NAME/`

**2.** 复制示例配置文件，并改名为 `*.my.*`。（`my` 只是标识符，你可以使用任意字符，例如 `self` `username` 等等）。

**3.** 修改 `.env` 文件 `SOFT_NAME_CONF` 值为文件名或目录名

## MySQL

**1.** 示例配置文件：`./config/mysql/docker.cnf`

**2.** 在示例配置文件夹内 `./config/mysql/` 复制 `docker.cnf` 为 `docker.my.cnf`

**3.** 在 `.env` 文件内修改 `LNMP_MYSQL_CONF` 变量值为 `docker.my.cnf`(默认是注释掉的，如果你按照本文方法操作，直接取消注释即可，或者修改为你自己认为合适的文件名)。

### 修改默认数据文件夹

假设自定义文件夹为 `/var/lib/mysql-my` (必须为绝对路径)

在 `docker.my.cnf` 中增加如下配置

```bash
[mysqld]

datadir         = /var/lib/mysql-my
```

在 `.env` 文件中修改 `LNMP_MYSQL_DATA=/var/lib/mysql-my`,之后启动即可。

> MariaDB 配置差不多，这里不再赘述。

### MySQL 自定义初始的 ROOT 密码

**1.** 在 `./secrets/` 新建 `*.txt` 文件，并写入密码。例如 `db.my.txt`

**2.** 在 `.env` 文件中设置 `LNMP_DB_ROOT_PASSWORD_PATH` 值为文件名，例如 `LNMP_DB_ROOT_PASSWORD_PATH=db.my.txt`

> 如果原来启动过，要么销毁（数据卷）之后重新启动，要么手动进入命令行修改密码。

## NGINX HTTPD

这两个软件的配置文件较多，详细说明一下：

**1.** 分清 `主配置文件` 和 `子配置文件`，本文假设你已经知道这两个概念，如果你实在不知道，请在本项目 GitHub 提出 `issue`

**2.** NGINX 主配置文件位于 `./config/etc/nginx/nginx.conf`，同理 HTTPD 主配置文件位于 `./config/etc/httpd/httpd.conf`

**3.** 复制 `nginx.conf` 为 `nginx.my.conf`，HTTPD 同理

**4.** 在 `./config` 目录中新建 `nginx.my` 文件夹，HTTPD 新建 `httpd.my` 文件夹

**5.** 我们以后就在 `nginx.my` 文件夹内新增 NGINX 子配置文件（请参照 `nginx` 文件中的示例配置），HTTPD 同理。为了方便备份配置文件，可以在 `./config/nginx.my` 文件夹中初始化一个 Git 仓库，通过 Git 管理配置文件。当你切换到另一个环境中，你可以很方便的通过 git clone url 快速恢复配置文件。

**6.** 修改 `.env` 文件 `LNMP_NGINX_CONF=nginx.my.conf` `LNMP_NGINX_CONF_D=nginx.my`，HTTPD 同理

## 简单的自定义 `php.ini` 配置

编辑 `./config/php/docker-php.ini` 文件。

> 当你需要更改大量的 `php.ini` 配置时，建议使用 `LNMP_PHP_INI` 变量定义自己的 `php.ini` 文件所在路径，这样就可以使用自己的 `php.ini` 文件了。

## 其他软件

不再赘述，如果你还是实在不知道该怎么正确的自定义配置，请在本项目 GitHub 提出 `issue`。
