# khs1994-dockeer/lnmp 支持文档

* [项目初衷](why.md)

* [路径说明](path.md)

* [开发环境 & 构建镜像](development.md)

* [lnmp-docker CLI](cli.md)

* [nginx & HTTPS 配置](nginx-with-https.md)

* PHP

  * [PHP 扩展列表](php.md)

  * [PhpStorm](phpstorm.md)

  * [xdebug](xdebug.md)

  * [laravel](laravel.md)

* [生产环境](production.md)

* [arm32v7 & arm64v8](arm.md)

* [空间占用情况](size.md)

* [备份](backup.md)

* [测试脚本](test.md)

* [Windows 10](windows.md)

* [常见问题](question.md)

## 安装 Docker CE

* [USTC mirror](http://mirrors.ustc.edu.cn/help/docker-ce.html)

* [Aliyun mirror](https://yq.aliyun.com/articles/110806)

### Ubuntu

```bash
$ curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) test"
$ sudo apt-get update
$ sudo apt-get -y install docker-ce
```

### Debian

### CentOS 7

## Docker Compose

windows 10 、macOS 中的 docker-ce 自带 docker-compose。

Linux x86_64 请在 [GitHub](https://github.com/docker/compose/releases) 下载二进制文件、或使用 Python 包管理工具 pip 进行安装。
