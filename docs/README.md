# khs1994-dockeer/lnmp 支持文档

安装 Docker CE 并配置 `镜像加速器`（阿里云等），并安装 [docker-compose](https://github.com/docker/compose/releases)。


* [项目初衷](why.md)

* [项目初始化过程](init.md)

* [国内网络问题](cn.md)

* [路径说明](path.md)

* [开发环境 && 构建镜像](development.md)

* [`lnmp-docker.sh` CLI](cli.md)

* [nginx & HTTPS 配置](nginx-with-https.md)

* PHP

  * [PHP 扩展列表](php.md)

  * [xdebug](xdebug.md)

  * [laravel](laravel.md)

  * [Composer](composer.md)

* [生产环境](production.md)

* [CI/CD](ci.md)

* [arm32v7 && arm64v8](arm.md)

* [备份 && 恢复](backup.md)

* [清理](cleanup.md)

* [Windows 10](windows.md)

* [常见问题](question.md)

> 务必分清本机路径和容器内路径，慎用 127.0.0.1 localhost，排查错误请使用 `docker logs` 命令查看日志。 

## More Information

* [Docker CE 安装教程](https://www.khs1994.com/docker/README.html)
* [docker-compose 安装教程](https://www.khs1994.com/docker/compose.html)
