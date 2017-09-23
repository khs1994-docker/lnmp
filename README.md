# LNMP Docker Compose

务必分清`本机`路径和`容器内`路径，请仔细对照 `docker-compose.yml` 文件，或阅读 [path.md](docs/path.md)。  
提前安装配置好 [`docker-compose`](https://www.khs1994.com/docker/compose.html)

# 更新记录

版本命名方式为（YY-MM），更新记录请查看 [Releases](https://github.com/khs1994-docker/lnmp/releases)

# 项目说明

## 文件夹结构

|文件夹|说明|
|--|--|
|`app`         |项目文件（HTML,PHP,etc）|
|`config`      |配置文件|               
|`dockerfile`  |自定义 Dockerfile|
|`logs`        |日志文件|
|`var`         |数据文件|
|`docs`        |支持文档|

## 端口暴露

* 80
* 443

# Usage

* 根据实际配置修改 `.env`
* 配置 `./config/php/xdebug.ini` 中的本机IP、本机端口
* 运行`初始化`脚本（完成 `docker-compose` 安装「由于国内网络问题可能会失败」、日志文件创建）

```bash
$ ./init.sh
```

* 更多用法请查看 [支持文档](https://github.com/khs1994-docker/lnmp/docs/)

## 启动

```bash
$ docker-compose up -d

$ curl 127.0.0.1
Welcome use khs1994-docker/lnmp
```

## 停止

```bash
$ docker-compose stop
```

## 销毁

```bash
$ docker-compose down
```

# LNMP 配置

各容器默认配置请到 [这里](https://github.com/khs1994-docker/lnmp-default-config) 查看

# More

* [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized)
* [zhaojunlike/docker-lnmp-redis](https://github.com/zhaojunlike/docker-lnmp-redis)
