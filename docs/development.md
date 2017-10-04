# 开发环境

## 构建镜像

请运行如下命令：

```bash
$ ./lnmp-docker.sh devlopment --build

$ curl 127.0.0.1

Welcome use khs1994-docker/lnmp v17.09-rc5 x86_64 With Build Docker Image

development

```

## 开发过程

克隆本项目

PhpStorm 打开本项目

克隆 PHP 项目文件到 `./app/`

### Linux, macOS, Windows 10(Git Bash)

`./lnmp-docker.sh composer` 交互式填入项目路径，要执行的命令，进行依赖的安装或升级

### Windows 10

修改 `./bin/docker-compose.windows.yml` 中 `volumes` 项目路径 `command` 要执行的命令

执行 `docker-compose -f bin/docker-compose.windows.yml up`
