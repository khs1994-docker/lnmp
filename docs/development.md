# 开发环境

## 使用方法

**1.** 在 `docker-compose.yml` 修改需要启用的软件

**2.** 在 `.env` 修改镜像前缀、PHP 项目路径

**3.** 克隆已有的 PHP 项目文件到 `./app/` 目录下，或新建 PHP 项目文件夹

**4.** 在 `./config/nginx/` 参考示例配置，新建 `nginx` 配置文件

   >可以使用 `./lnmp-docker.sh new` 交互式的填入 `项目路径` 和 `url` 来新建 PHP 项目文件及 nginx 配置文件。


   >可以使用 `./lnmp-docker.sh nginx-conf` 便捷的生成 nginx 配置文件。

   >使用 `./lnmp-docker.sh ...`，请务必仔细检查 nginx 文件是否配置正确。

**5.** 执行 `./lnmp-docker.sh development`

**6.** `PhpStorm` 打开 `./app/你的项目` ，开始编写代码

### 再新建一个项目

**1.** `./app` 新建项目文件，`./config/nginx/` 新增配置文件

**2.** 执行 `./lnmp-docker.sh restart nginx` 重启 nginx

**3.** `PhpStorm` 打开 `./app/你的又一个新项目` ，开始编写代码

## 自行构建镜像

在 `./dockerfile/` 下修改各个软件 `Dockerfile` 文件，之后运行如下命令：

```bash
$ ./lnmp-docker.sh build

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.11 x86_64 With Build Docker Image

development

```

## 其他问题

* 在 IDE 中运行 PHPUnit 测试 Laravel 程序时，提示连接不到 Redis MySQL 怎么办？

  ```bash
  # 设置 hosts

  $ vi /etc/hosts

  127.0.0.1 redis mysql
  ```
