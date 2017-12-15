# LinuxKit Run LNMP

编写 PHP 项目源代码(必须包含 `Dockerfile`)

本地测试

推送到 GitHub

在 `./linuxkit` 目录下执行以下命令构建镜像并运行。

```bash
$ docker-compose build

# $ docker-compose push

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

* https://github.com/linuxkit/linuxkit
