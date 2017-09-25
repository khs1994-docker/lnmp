# khs1994-dockeer/lnmp 支持文档

* [PhpStorm](phpstorm.md)

* [lnmp-docker CLI](cli.md)

* [nginx & HTTPS](https.md)

* [PHP 扩展列表](php.md)

* [xdebug](xdebug.md)

* [laravel](laravel.md)

* [生产环境](production.md)

* [arm32v7 & arm64v8](arm.md)

* [备份](backup.md)

* [路径说明](path.md)

* [测试脚本](test.md)

* [常见问题](question.md)

# 安装 Docker CE

* [Aliyun mirror](https://yq.aliyun.com/articles/110806)
* [ mirror]()

## Ubuntu

```
$ curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) test"
$ sudo apt-get update
$ sudo apt-get -y install docker-ce
```

# Docker Compose

windows 10 、macOS 中的 docker-ce 自带 docker-compose。

Linux 请在 GitHub 下载二进制文件、或使用 Python 包管理工具 pip 进行安装。
