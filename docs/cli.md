# 命令行工具简要说明

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

为避免输入过多的命令，本项目提供了 **命令行** 工具来简化操作：

* 各种场景和架构中一键启动

* 便捷生成 `NGINX` `APACHE` 配置文件

## 尽量兼容原始命令

例如 `lnmp-docker up | down` 对应着 `docker-compose up | down`

`lnmp-k8s create | delete ` 对应着 `kubectl create | delete`

## 原始命令详解

### 初始化

请查看 [项目初始化过程](init.md)。

### docker-compose 原始命令

使用 `docker-compose` 来启动、停止、销毁容器的参数分别是 `up -d` `stop` `down`，通过 `-f` 来加载 `docker-compose.yml` (可以任意命名，也可以是 json 格式)，本项目的 CLI 就是对以上一些命令的封装。

|场景|CLI|原始命令|
|:--|:--|:-|
|开发环境 拉取镜像  | `$ ./lnmp-docker up` |`docker-compose up -d`                                                            |
|开发环境 构建镜像  | `$ ./lnmp-docker build`       |`docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d`          |
|ARM             | `$ ./lnmp-docker up` |`docker-compose -f docker-arm.yml up -d`                                          |
|生产环境         | `$ ./lnmp-docker swarm-deploy` |`docker stack -c docker-production.yml lnmp`                                      |

>`docker-compose.override.yaml` 是为了重写 `docker-compose.yaml`，执行 `docker-compose up -d` 会默认加载该文件。

调试参数配置时请把 `up -d` 替换为 `config` 即可。
