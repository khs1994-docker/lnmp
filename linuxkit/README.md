# LinuxKit Run LNMP

>注意，暂不支持 MySQL

编写 PHP 项目源代码(必须包含 `Dockerfile`)

本地测试

推送到 GitHub

在 `./linuxkit` 目录下修改 `docker-compose.yml` 的构建路径，并执行以下命令构建镜像并运行。

```bash
$ docker-compose build

# $ docker-compose push

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

浏览器打开 `127.0.0.1:8080`

关闭

```bash
# 按一下 enter 才能进入终端

$ halt
```

# Moree Information

* https://github.com/linuxkit/linuxkit

* https://www.khs1994.com/docker/linuxkit.html
