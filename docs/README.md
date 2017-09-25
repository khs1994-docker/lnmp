# khs1994-dockeer/lnmp 支持文档

* [PhpStorm](phpstorm.md)

* [lnmp-docker CLI](cli.md)

* [HTTPS](https.md)

* [PHP 扩展列表](php.md)

* [xdebug](xdebug.md)

* [laravel](laravel.md)

* [生产环境](production.md)

* [备份](backup.md)

* [路径说明](path.md)

* [测试脚本](test.md)

# 安装 Docker CE

* [Aliyun mirror](https://yq.aliyun.com/articles/110806)

## Ubuntu

```
$ curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) test"
$ sudo apt-get update
$ sudo apt-get -y install docker-ce
```
