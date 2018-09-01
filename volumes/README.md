# Docker Volumes

提供 **Volume** 各种驱动的配置方法

# NFS

之前本项目默认的 PHP 项目目录为 `./app`，你可以通过设置 `APP_ROOT` 变量来设置 PHP 项目目录。

假设你想要 PHP 项目目录 `app` 与本项目并列那么可以进行如下设置。

```bash
# APP_ROOT="../app"

APP_ROOT="../../app"
```
