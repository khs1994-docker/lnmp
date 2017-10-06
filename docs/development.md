# 开发环境

## 构建镜像

请运行如下命令：

```bash
$ ./lnmp-docker.sh devlopment --build

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.09 x86_64 With Build Docker Image

development

```

## 开发过程

克隆本项目

PhpStorm 打开本项目

克隆 PHP 项目文件到 `./app` 目录下

在 `./config/nginx/` 新建 nginx 配置文件

### Linux, macOS, Windows 10(Git Bash)

`./lnmp-docker.sh composer` 交互式填入项目路径，要执行的命令，进行依赖的安装或升级

### Windows 10

修改 `./bin/docker-compose.windows.yml`

其中 `volumes` 为项目路径， `command` 为要执行的命令

执行 `docker-compose -f bin/docker-compose.windows.yml up`

### 命令行执行 PHP 文件

路径为相对于 `./app` 的目录名。

```bash
$ ./lnmp-docker.sh php blog index.php
```
