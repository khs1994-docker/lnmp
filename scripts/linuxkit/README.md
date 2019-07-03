# 使用 LinuxKit 运行 LNMP

[![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

>注意，暂不支持 MySQL

本地编写 `PHP` 项目源代码（必须包含 `Dockerfile`）及 `nginx` 配置文件。

本地测试

将 `PHP` 项目源代码推送到 GitHub，CI/CD 开始构建 `PHP` 镜像。

编写生产环境 `nginx` 配置文件，并推送到 GitHub，CI/CD 开始构建 `nginx` 镜像。

执行以下命令构建镜像并运行。

```bash
# 分别构建 nginx php7 镜像

$ cd app/demo

$ docker-compose build

$ cd ../../config/nginx

$ docker-compose build

$ cd ~/lnmp/scripts/linuxkit

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

浏览器打开 `127.0.0.1:8080`

关闭

```bash
# 按一下 enter 才能进入终端

$ halt
```

# More Information

* https://github.com/linuxkit/linuxkit

* https://blog.khs1994.com/docker/linuxkit.html
