# 个性化方案

本项目提供的默认环境可能不符合开发者实际的需求，例如想增加一个软件、更改一项配置。下面提供一些典型案例。

## 自定义所启动的服务

例如使用 `httpd` 替换 `nginx`。

编辑 `.env` 文件，在 `LNMP_SERVICES` 变量中增加软件名

```diff
- LNMP_SERVICES="nginx mysql php8 redis" # 默认配置

+ LNMP_SERVICES="httpd mysql php8 redis" # 使用 httpd 代替 nginx

+ LNMP_SERVICES="httpd mysql php8 redis mongodb" # 增加 mongodb
```

## 使用自己的镜像

> **不想使用本项目默认的镜像，可以！**

你可以参考下一小节的 **自定义镜像** 使用自己的镜像。

## 通过修改 `docker-lnmp.override.yml` 文件自定义本项目

编辑 `docker-lnmp.override.yml` 文件，增加服务名，修改指令即可。

**建议每次修改之后执行 `$ lnmp-docker config > docker-compose.yaml` 查看配置是否正确，之后启动。**

### 自定义镜像

```yaml
# docker-lnmp.override.yml


services:
  php8:
    # 想修改哪个配置在这里重写即可，例如想使用自己的 PHP 镜像或国内镜像，那么增加 `image` 指令即可
    image: ccr.ccs.tencentyun.com/khs1994/php:${LNMP_PHP_VERSION:-8.2.13}-fpm-alpine
```

你也可以加上 `build` 字段，先构建镜像再启动

```yaml
# docker-lnmp.override.yml


services:
  php8:
    image: ccr.ccs.tencentyun.com/khs1994/php:${LNMP_PHP_VERSION:-8.2.13}-fpm-alpine
    # 增加 build 字段
    build:
      context: ./dockerfile/php/
```

```bash
$ ./lnmp-docker build [SERVICE...]

$ ./lnmp-docker up
```

### 自定义数据卷

> 例如我们想增加一个数据卷挂载，将本机 `/path/src` 挂载到 PHP 容器中的 `/path/target`

```yaml
# docker-lnmp.override.yml


services:
  php8:
    volumes:
      - /path/src:/path/target
```

> 再例如 `MySQL` 默认将容器目录 `/var/lib/mysql` 映射到了宿主机中的数据卷，但我们想映射到宿主机的 `/path/mysql` 目录

```yaml
# docker-lnmp.override.yml


services:
  mysql:
    volumes:
      - /path/mysql:/var/lib/mysql
```

### 增加一个服务

```yaml
# docker-lnmp.override.yml


services:
  my_add_service:
    image: username/image
```

参考最开始的小节，在 `.env` 文件中修改 `LNMP_SERVICES` 变量，增加服务名。

## 单独启动某个软件

> **我想单独启动某个软件，可以！**

```bash
$ lnmp-docker up SOFT_NAME SOFT_NAME2

# $ lnmp-docker up kong-dashboard

# $ lnmp-docker up kong kong-dashboard
```

## 使用自己的镜像(除使用官方镜像的服务以外)

`.env` 文件更改以下变量

```bash
# LNMP_DOCKER_IMAGE_PREFIX=khs1994

LNMP_DOCKER_IMAGE_PREFIX=username
```
