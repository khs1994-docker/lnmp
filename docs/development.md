# 开发环境

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 使用方法

**1.** **可选项** 在 `.env` 文件中通过 `LNMP_SERVICES` 变量修改需要启用的软件，详细说明请参考 [个性化方案](custom.md)

**2.** **可选项** 如果你想使用自己的镜像，可以在 `.env` 文件中通过 `LNMP_DOCKER_IMAGE_PREFIX` 变量修改镜像前缀，默认为 `khs1994`，详细说明请参考 [自己构建镜像](build.md)

**3.** **可选项** 在 `.env` 文件中通过 `LNMP_PHP_PATH` 变量修改 **容器** 内 PHP 项目路径，默认为 `/app`

**4.** 从 **Git 克隆** 或 **移动** 或 **新建** PHP 项目文件 `./app/my-project` (可自定义，请查看下方 `APP_ROOT` 一节)

**5.** 在 `./config/nginx/` 参考示例配置，新建 `nginx` 配置文件(`./config/nginx/*.conf`)

**6.** 执行 `./lnmp-docker up` 或者 `./lnmp-docker restart nginx` 启动或重启

**7.** `IDE(PhpStorm、VSCode)` 打开 `./app/my-project` ，开始编写代码

**8.** VSCode 远程开发请参考 `vscode-remote` 文件夹

## APP_ROOT

默认的 PHP 项目目录位于 `./app/*`，你可以通过在 `.env` 文件中设置 `APP_ROOT` 变量来更改 PHP 项目目录。

例如你想要将 PHP 项目目录 `app` 与本项目并列：

```diff
# .env
- APP_ROOT=./app
+ APP_ROOT=../app
```

此时文件夹结构为

```bash
.
├── app    # 项目文件夹
└── lnmp   # khs1994-docker/lnmp
```

我们也可以将项目放置于 **WSL2** 中，例如我们想要将项目文件放置于 **WSL2** `Ubuntu` 中的 `/app/*` 目录，那么请在 `.env` 和 `.env.ps1` 中进行如下设置

```bash
# .env
APP_ROOT=/app
```

```powershell
# .env.ps1
$WSL2_DIST="ubuntu"
```

## 如何正确的自定义配置文件

以上是简单的配置方法，如果你有兴趣持续使用本项目作为你的 LNMP 环境，那么请 **正确** 的修改配置文件。请查看 [这里](config.md)

## 使用 CLI 交互式的创建 PHP 项目

执行 `./lnmp-docker new` 新建项目

### 生成 NGINX 配置文件

`./lnmp-docker nginx-conf` 便捷的生成 nginx 配置文件(包括 HTTP HTTPS)

## PHPStorm

想要在 PHPStorm 中实现右键点击运行测试脚本必须进行额外的设置，请查看 [PHP 容器化最佳实践](https://github.com/khs1994-docker/php-demo#6-cli-settings)

## 容器数量伸缩

```bash
# 扩容
$ ./lnmp-docker scale php7=3

# 缩容
$ ./lnmp-docker scale php7=1
```

## 保持运行的软件最新

在 `.env` 文件中注释掉 `LNMP_SOFT_VERSION` 变量，例如

```diff
- LNMP_NGINX_VERSION=1.17.9
+ # LNMP_NGINX_VERSION=1.17.9
```

## 危险的命令

**$ docker volume prune** 执行 `$ lnmp-docker down` 之后执行该命令将会删除数据卷（例如：数据库数据）
