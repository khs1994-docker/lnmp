# 命令行工具简要说明

只适用于 Linux、macOS，为避免输入过多的命令，编写了命令行工具简化用户使用，提供了以下功能：

* 各种场景和架构中一键启动

* 安装 Laravel 项目

* 使用 Laravel artisan

* 使用 Composer

* 生产环境使用 Composer 安装 PHP 项目依赖包

## 原始命令详解

### 初始化

请查看 [项目初始化过程](init.md)。

### docker-compose 原始命令

使用 `docker-compose` 来启动、停止、销毁容器的参数分别是 `up -d` `stop` `down`，通过 `-f` 来加载 `docker-compose.yml` (可以任意命名，也可以是 json 格式)，本项目的 CLI 就是对以上一些命令的封装。

|场景|原始命令|
|:--|:--|
|开发环境 拉取镜像*|`docker-compose up -d`|
|开发环境 构建镜像|`docker-compose -f docker-compose.yaml -f docker-compose.build.yml up -d`|
|生产环境        |`docker-compose -f docker-compose.yaml -f docker-compose.prod.yml up -d`|
|arm32v7        |`docker-compose -f docker-compose.arm32v7.yaml up -d`|
|arm64v8        |`docker-compose -f docker-compose.arm64v8.yaml up -d`|

备注： `docker-compose.override.yaml` 是为了重写 `docker-compose.yaml`，执行 `docker-compose up -d` 会默认加载该文件。

调试参数配置请把 `up -d` 替换为 `config` 即可。
