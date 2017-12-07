# 使用 LinuxKit 运行 LNMP

实验性支持

>目前暂不支持 MySQL

编写 PHP 项目源代码

本地测试

推送到 GitHub

构建镜像（镜像中包含 PHP 项目文件）

在 `./dockerfile` 目录下的 `nginx` `php-fpm` 子目录中修改 `Dockerfile.linuxkit` 文件。

在 `./linuxkit` 目录下执行

```bash
$ docker-compose build

$ docker-compose push

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```
