# 使用 LinuxKit 运行 LNMP

>注意，暂不支持 MySQL

本地编写 `PHP` 项目源代码（必须包含 `Dockerfile`）及 `nginx` 配置文件。

本地测试

将 `PHP` 项目源代码推送到 GitHub，CI/CD 开始构建 `PHP` 镜像。

编写生产环境 `nginx` 配置文件，并推送到 GitHub，CI/CD 开始构建 `nginx` 镜像。

执行以下命令构建镜像并运行。

```bash
$ docker-compose -f docker-stack.yml build

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
