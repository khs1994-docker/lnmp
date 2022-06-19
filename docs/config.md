# 软件配置

自定义软件配置是最重要的一项功能，为了方便本项目升级，严禁直接修改 `./config` 下的原始配置文件。

下面详细介绍如何正确的自定义配置。

## 原则

* 以追加(子配置文件 **重写** 主配置文件、后边的 **重写** 前边的)方式进行配置

* 尽量一个软件一个配置文件

## 总体步骤（三步）

**1.** 进入配置文件所在目录 `./config/SOFT_NAME/`

**2.** 复制示例配置文件，并改名为 `*.my.*`。（`my` 只是标识符，你可以使用任意字符，例如 `self` `username` 等等）。

**3.** 修改 `.env` 文件 `SOFT_NAME_CONF` 值为文件名或目录名

## NGINX HTTPD

这两个软件的配置文件较多，详细说明一下：

**1.** 分清 `主配置文件` 和 `子配置文件`，本文假设你已经知道这两个概念，如果你实在不知道，请在本项目 GitHub 提出 `issue`

**2.** NGINX 主配置文件位于 `./config/etc/nginx/nginx.conf`，同理 HTTPD 主配置文件位于 `./config/etc/httpd/httpd.conf`

**3.** 复制 `nginx.conf` 为 `nginx.my.conf`，HTTPD 同理

**4.** 在 `./config` 目录中新建 `nginx.my` 文件夹，HTTPD 新建 `httpd.my` 文件夹

**5.** 我们以后就在 `nginx.my` 文件夹内新增 NGINX 子配置文件（请参照 `nginx` 文件中的示例配置），HTTPD 同理。为了方便备份配置文件，可以在 `./config/nginx.my` 文件夹中初始化一个 Git 仓库，通过 Git 管理配置文件。当你切换到另一个环境中，你可以很方便的通过 git clone url 快速恢复配置文件。

**6.** 修改 `.env` 文件 `LNMP_NGINX_CONF=nginx.my.conf` `LNMP_NGINX_CONF_D=nginx.my`，HTTPD 同理

## PHP

### 简单的自定义 `php.ini` 配置

编辑 `./config/php/docker-php.ini` 文件。

> 当你需要更改大量的 `php.ini` 配置时，请编辑 `./config/php/php.ini`

> php.ini 支持系统变量 `key=${VAR}`，故可以通过设置系统变量来自定义配置

## MySQL

* 在 `./config/mysql/conf.d/my.cnf` 文件中增加配置项即可

## 其他软件

不再赘述，如果你还是实在不知道该怎么正确的自定义配置，请在本项目 GitHub 提出 `issue`。
