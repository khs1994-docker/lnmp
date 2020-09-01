# 命令行工具

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

为避免输入过多的命令，本项目提供了 **命令行** 工具 `lnmp-docker` 来简化操作：

* 各种场景和架构中一键启动

* 便捷生成 `NGINX` `APACHE` 配置文件

## 尽量兼容原始命令

例如 `lnmp-docker up | down` 对应着 `docker-compose up | down`

## 自定义 CLI

可以在 `lnmp-docker-custom-script` 或 `lnmp-docker-custom-script.ps1` (Windows) 中编写自定义脚本。

**例如：** 你需要在执行 `lnmp-docker up` 命令后执行一些操作那么可以编写 `__lnmp_custom_up` 函数。

## 命令行补全

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

设置环境变量 `LNMP_PATH` 为本项目的绝对路径(下面以 `/data/lnmp` 为例，实际请替换为你自己的路径)，并加入到 `PATH`，这样你就可以在任意目录使用本项目的 CLI。

### 1. Bash

```bash
$ vi ~/.bash_profile

export LNMP_PATH=/data/lnmp

export PATH=$LNMP_PATH:$LNMP_PATH/bin:$PATH
```

#### Linux

```bash
$ sudo ln -s $LNMP_PATH/cli/completion/bash/lnmp-docker /etc/bash_completion.d/lnmp-docker
```

#### macOS

```bash
$ sudo ln -s $LNMP_PATH/cli/completion/bash/lnmp-docker /usr/local/etc/bash_completion.d/lnmp-docker
```

### 2. fish

```bash
$ set -Ux LNMP_PATH /data/lnmp

$ ln -s $LNMP_PATH/cli/completion/fish/lnmp-docker.fish ~/.config/fish/completions/
```

> 删除环境变量 `$ set -Ue LNMP_PATH`

### 3. zsh

```bash
$ vi ~/.zshrc

export LNMP_PATH=/data/lnmp

export PATH=$LNMP_PATH:$LNMP_PATH/bin:$PATH
```

## 原始命令详解

### 初始化

请查看 [项目初始化过程](init.md)。

### docker-compose 原始命令

使用 `docker-compose` 来启动、停止、销毁容器的参数分别是 `up -d` `stop` `down`，通过 `-f` 来加载 `docker-compose.yml` (可以任意命名)，本项目的 CLI 就是对以上一些命令的封装。

|场景|CLI|原始命令|
|:--|:--|:-|
|开发环境(使用拉取的镜像)  | `$ ./lnmp-docker up`           |`docker-compose -f docker-lnmp.yml -f docker-lnmp.override.yml up -d`                                                            |
|开发环境(使用构建的镜像)  | `$ ./lnmp-docker build`        |`docker-compose -f docker-lnmp.yml -f docker-lnmp.build.yml up -d`         |
|生产环境                 | `$ ./lnmp-docker swarm-deploy` |`docker stack -c docker-production.yml lnmp`                                   |

>`docker-compose.override.yaml` 是为了重写 `docker-compose.yaml`，执行 `docker-compose up -d` 会默认加载该文件。

你可以使用 `config` 命令查看最终的 `docker compose` 配置文件。

### 使用 docker-compose 命令

> 我就是不想使用你提供的 `lnmp-docker` `CLI`，我就要使用 `docker-compose` 命令，怎们办？

本项目支持生成标准的 `docker-compose.yml` 文件，执行以下命令即可。

**注意: 每次修改 .env 文件，必须重新执行此命令**

```bash
$ ./lnmp-docker config > docker-compose.yml
```

之后就可以使用 `docker-compose` 命令

```bash
$ docker-compose up -d $(./lnmp-docker services)

$ docker-compose down
```

### 根据环境的不同使用不同的 `.env.${LNMP_ENV}` 文件

> 原理：使用 compose 1.25.0 新增的 `--env-file PATH` 选项

假设你需要在 `development（开发）` `production（生产）` 两个环境中使用本项目

那么在 `development` 环境中，新增 `.env.development` 文件（内容参照 `.env.example`）,并设置环境变量 `LNMP_ENV=development`

```bash
$ export LNMP_ENV=development
# windows powershell
# $env:LNMP_ENV="development"

$ ./lnmp-docker
```

`production` 环境同理，不再赘述。

> 注意，本项目不会自动生成 `.env.${LNMP_ENV}` 文件，如果找不到 `.env.${LNMP_ENV}` 文件，将使用 `.env` 文件。
