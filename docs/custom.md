# 个性化方案

本项目提供的默认环境可能不符合开发者实际的需求，例如想增加一个软件、更改一项配置。下面提供一些典型案例。

## 自定义所启动的服务

例如使用 `httpd` 替换 `nginx`。

编辑 `.env` 文件，在 `LNMP_SERVICES` 变量中增加软件名

```diff
- LNMP_SERVICES="nginx mysql php7 redis phpmyadmin" # 默认配置

+ LNMP_SERVICES="httpd mysql php7 redis" # 使用 httpd 代替 nginx

+ LNMP_SERVICES="httpd mysql php7 redis mongodb" # 增加 mongodb
```

## 使用自己的镜像

> **不想使用本项目默认的镜像，可以！**

在 `./dockerfile/` 下各个软件的文件夹内复制 `example.Dockerfile` 为 `Dockerfile`，并编写 `Dockerfile` 之后运行如下命令：

```bash
$ ./lnmp-docker build

$ ./lnmp-docker build-up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.06 x86_64 With Build Docker Image

development

```

## 增加服务

> **这个项目能不能增加 xxx 软件，可以！**

请查看 [lrew](lrew.md)

## 单独启动某个软件

> **我想单独启动某个软件，可以！**

```bash
$ lnmp-docker up SOFT_NAME SOFT_NAME2

# $ lnmp-docker up kong-dashboard

# $ lnmp-docker up kong kong-dashboard
```

## 自定义数据卷

> **我想把某个软件的目录挂载到本机，可以！**

> 例如我们想增加一个数据卷挂载，将本机 `/path/src` 挂载到 PHP 容器中的 `/path/target`

编辑 `docker-lnmp.include.yml` 文件，重写默认的 `php7` 服务。

```yaml
version: "3.7"

services:
  php7:
    volumes:
      - /path/src:/path/target
```

> 再例如 `MySQL` 默认将容器目录 `/var/lib/mysql` 映射到了宿主机中的数据卷，但我们想映射到宿主机的 `/path/mysql` 目录

同样的编辑 `docker-lnmp.include.yml` 文件，重写默认的 `MySQL` 服务。

```yaml
version: "3.7"

services:
  mysql:
    volumes:
      - /path/mysql:/var/lib/mysql
```

执行 `$ lnmp-docker config` 查看配置是否正确，之后启动。

## 自定义 compose 文件配置

> **软件的默认配置不满足我的要求（例如这个软件我想使用别的镜像），怎么修改**

编辑 `docker-lnmp.include.yml` 文件，增加服务名，修改指令即可。

> 例如想自定义 `php7` 服务的配置，我们先增加 php7 这个条目。

```yaml
version: "3.7"

services:
  php7:
    # 想修改哪个配置在这里重写即可，例如想使用自己的 PHP 镜像，那么增加 `image` 指令即可
    image: username/image:tag
```
