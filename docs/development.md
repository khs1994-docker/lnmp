# 开发环境

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 使用方法

**1.** 在 `.env` 文件中通过 `LNMP_INCLUDE` 变量修改需要启用的软件，详细说明在本文最后(可选项)

**2.** 在 `.env` 文件中通过 `LNMP_DOCKER_IMAGE_PREFIX` 变量修改镜像前缀，默认为 khs1994，你可以自由的定义镜像前缀来使用你自己的镜像(可选项)

**3.** 在 `.env` 文件中通过 `LNMP_PHP_PATH` 变量修改 **容器** 内 PHP 项目路径，默认为 `/app` (可选项)

**4.** 从 Git 克隆或移动已有的 PHP 项目文件到 `./app/` 目录下(可自定义，请查看下方 `APP_ROOT` 一节)，或新建 PHP 项目文件夹

**5.** 在 `./config/nginx/` 参考示例配置，新建 `nginx` 配置文件(`./config/nginx/*.conf`)

**6.** 执行 `./lnmp-docker up` 或者 `./lnmp-docker restart nginx`

**7.** `PhpStorm` 打开 `./app/project` ，开始编写代码

### 再新建一个项目

**1.** `./app` 新建项目文件夹，`./config/nginx/` 新增配置文件

**2.** 执行 `./lnmp-docker restart nginx` 重启 nginx

**3.** `PhpStorm` 打开 `./app/new-project` ，开始编写代码

## APP_ROOT

默认的 PHP 项目目录位于 `./app/*`，你可以通过在 `.env` 文件中设置 `APP_ROOT` 变量来更改 PHP 项目目录。

例如你想要将 PHP 项目目录 `app` 与本项目并列

```bash
# APP_ROOT=./app
APP_ROOT=../app
```

### Windows

Windows 除了在 `.env` 文件中设置 `APP_ROOT` 变量外，还需在 `.env.ps1` 中进行如下设置

```bash
# $global:APP_ROOT="./app"
$global:APP_ROOT="../app"
```

## 如何正确的自定义配置文件

以上是简单的配置方法，如果你有兴趣持续使用本项目作为你的 LNMP 环境，那么请 **正确** 的修改配置文件。请查看 [这里](config.md)

## 使用 CLI 交互式的创建 PHP 项目

执行 `./lnmp-docker new` 新建项目

### 生成 NGINX 配置文件

`./lnmp-docker nginx-conf` 便捷的生成 nginx 配置文件(包括 HTTP HTTPS)

## PHPStorm

想要在 PHPStorm 中实现右键点击运行脚本必须进行额外的设置

具体请查看 PHP 容器化最佳实践 https://github.com/khs1994-docker/php-demo#6-cli-settings

## 自行构建镜像

在 `./dockerfile/` 下各个软件的文件夹内复制 `example.Dockerfile` 为 `Dockerfile`，并编写 `Dockerfile` 之后运行如下命令：

```bash
$ ./lnmp-docker build

$ ./lnmp-docker build-up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.06 x86_64 With Build Docker Image

development

```

## 容器数量伸缩

```bash
$ ./lnmp-docker scale php7=3

$ ./lnmp-docker scale php7=1
```

## 自定义启动软件

编辑 `.env` 文件，在 `LNMP_INCLUDE` 变量中增加软件名

```bash
LNMP_INCLUDE="nginx mysql php7 redis phpmyadmin" # 默认配置

LNMP_INCLUDE="httpd mysql php7 redis" # 使用 httpd 代替 nginx

LNMP_INCLUDE="httpd mysql php7 redis mongodb" # 增加 mongodb
```

### Windows

编辑 `lnmp-docker.ps1`

```bash
$global:LNMP_INCLUDE='nginx','mysql','php7','redis','phpmyadmin' # 默认配置

$global:LNMP_INCLUDE='httpd','mysql','php7','redis' # 使用 httpd 代替 nginx

$global:LNMP_INCLUDE='httpd','mysql','php7','redis','mongodb' # 增加 mongodb
```

### 增加服务

在 `docker-compose.include.yml` 文件中新增服务。

在 `.env` 文件中增加服务名

```bash
LNMP_INCLUDE="nginx mysql php7 redis phpmyadmin my-service"
```

### 自定义脚本

新建 `lnmp-custom-script` shell 脚本。

### 自定义卷

> 例如我们想增加一个数据卷挂载，将本机 `/path/my_path` 挂载到 PHP 容器中的 `/path/target`

编辑 `docker-compose.include.yml` 文件

```yaml
version: "3.7"

services:
  php7:
    volumes:
      - /path/my_path:/path/target
```

> 再例如 `MySQL` 默认将容器目录 `/var/lib/mysql` 映射到了宿主机中的数据卷，但我们想映射到宿主机的 `/path/mysql` 目录

同样的编辑 `docker-compose.include.yml` 文件

```yaml
version: "3.7"

services:
  mysql:
    volumes:
      - /path/mysql:/var/lib/mysql
```

执行 `$ lnmp-docker config` 查看配置是否正确，之后启动。

## 自定义 compose 文件配置

编辑 `docker-compose.include.yml` 文件，增加服务名，修改指令即可。

> 例如我们想自定义 `php7` 服务的配置，我们先增加 php7 这个条目。

```yaml
version: "3.7"

services:
  php7:
    # 想修改哪个在这里重写即可，例如我们想使用自己的 PHP 镜像，那么增加 `image` 指令即可
    image: username/image:tag
```
