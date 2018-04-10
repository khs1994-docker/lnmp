# 开发环境

## 使用方法

**1.** 在 `docker-compose.yml` 修改需要启用的软件(可选项)

**2.** 在 `.env` 修改镜像前缀、PHP 项目路径(可选项)

**3.** 从 Git 克隆或移动已有的 PHP 项目文件到 `./app/` 目录下，或新建 PHP 项目文件夹

**4.** 在 `./config/nginx/` 参考示例配置，新建 `nginx` 配置文件(`./config/nginx/*.conf`)

**5.** 执行 `./lnmp-docker.sh development` 或者 `./lnmp-docker.sh restart nginx`

**6.** `PhpStorm` 打开 `./app/你的项目` ，开始编写代码

### 再新建一个项目

**1.** `./app` 新建项目文件夹，`./config/nginx/` 新增配置文件

**2.** 执行 `./lnmp-docker.sh restart nginx` 重启 nginx

**3.** `PhpStorm` 打开 `./app/你的又一个新项目` ，开始编写代码

## 如何正确的自定义配置文件

以上是简单的配置方法，如果你有兴趣持续使用本项目作为你的 LNMP 环境，那么请 **正确** 的修改配置文件。请查看 [这里](config.md)

## 使用 CLI 交互式的创建 PHP 项目

执行 `./lnmp-docker.sh new` 新建项目

### 生成 NGINX 配置文件

`./lnmp-docker.sh nginx-conf` 便捷的生成 nginx 配置文件(包括 HTTP HTTPS)

## 自行构建镜像

在 `./dockerfile/` 下修改各个软件的文件夹内复制 `example.Dockerfile` 为 `Dockerfile`，并编写 `Dockerfile` 之后运行如下命令：

```bash
$ ./lnmp-docker.sh build

$ ./lnmp-docker.sh build-up

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v18.06 x86_64 With Build Docker Image

development

```

## 其他问题

* 在 IDE 中运行 PHPUnit 测试 Laravel 程序时，提示连接不到 Redis MySQL 怎么办？

  ```bash
  # 设置 hosts

  $ vi /etc/hosts

  127.0.0.1 redis mysql
  ```

## 容器数量伸缩

```bash
$ ./lnmp-docker.sh scale php7=3

$ ./lnmp-docker.sh scale php7=1
```

## 一次启动更多软件 ？

编辑 `.env` 文件，在 `DEVELOPMENT_INCLUDE` 变量中增加软件名

```bash
DEVELOPMENT_INCLUDE="nginx mysql php7 redis phpmyadmin" # 默认配置

DEVELOPMENT_INCLUDE="httpd mysql php7 redis" # 使用 httpd 代替 nginx

DEVELOPMENT_INCLUDE="httpd mysql php7 redis mongodb" # 增加 mongodb
```

### Windows

编辑 `lnmp-docker.ps1`

```bash
$global:DEVELOPMENT_INCLUDE='nginx','mysql','php7','redis','phpmyadmin' # 默认配置

$global:DEVELOPMENT_INCLUDE='httpd','mysql','php7','redis' # 使用 httpd 代替 nginx

$global:DEVELOPMENT_INCLUDE='httpd','mysql','php7','redis','mongodb' # 增加 mongodb
```
