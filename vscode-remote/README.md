# Linux Docker + vsCode 远程开发

* https://code.visualstudio.com/docs/remote/containers

**桌面版 Docker + vsCode 远程开发请查看对应的 README 文件。**

> 本文件夹中的示例 一个项目配置一个 vsCode 远程开发配置文件。

> 或者你可以将整个 /app 作为一个项目，避免繁琐的配置。具体请参考 lnmp 根目录的 `.devcontainer` 文件夹及 `docker-workspace.yml` 文件。文档 https://docs.lnmp.khs1994.com/laravel.html

## 说明

`工具链(PHP)` `vsCode Server` 位于容器, `vsCode` 位于本地

## 准备

**项目文件夹**

1. 将 `.devcontainer` `docker-workspace.yml` 复制到 PHP 项目文件夹根目录,并作适当调整(搜索 `fix me`)

**创建数据卷**

```bash
$ docker volume create lnmp_composer-cache-data
$ docker volume create lnmp_npm-cache-data
```

**工具准备**

2. `vsCode` 安装 `Remote Development` 扩展

```bash
$ code --install-extension ms-vscode-remote.remote-containers
```

3. 启动 `khs1994-docker/lnmp`

```bash
$ ./lnmp-docker up
```

## PHP 相关的 vsCode 扩展

* `felixfbecker.php-debug`
* 更多扩展请查看 https://github.com/khs1994-docker/lnmp/blob/master/.devcontainer/devcontainer.json **extensions** 项

## 步骤

1. 打开 `vsCode`(`$ code`)

2. 按 `F1`键（或者点击左下角【打开远程窗口】）, select `Remote-Containers: Open Folder in Container...`. 选择项目文件夹(包含 `.devcontainer`, `docker-workspace.yml`).

**注意事项**

1. 扩展需要在 `远程` 安装(以前安装过的扩展在 **远程** 重新安装)

2. 首次使用,需要初始化,请耐心等待

## 依赖管理(执行 composer 命令)

**安装依赖**

```bash
$ docker-compose -f docker-workspace.yml run --rm composer install
```

**安装新的依赖**

```bash
$ docker-compose -f docker-workspace.yml run --rm composer require XXX
```

**升级依赖**

```bash
$ docker-compose -f docker-workspace.yml run --rm composer update
```

**或者执行**

```bash
$ lnmp-docker composer install | update | require XXX
```

## Xdebug

**1. 在 `khs1994-docker/lnmp` 配置(启用) Xdebug**

参考 https://docs.lnmp.khs1994.com/xdebug.html

* 端口: 9003
* 远程地址: 192.168.199.100(宿主机 IP，根据实际修改)

* 2. [浏览器安装 `xdebug` 扩展](https://docs.lnmp.khs1994.com/xdebug.html#%e6%b5%8f%e8%a7%88%e5%99%a8%e6%89%a9%e5%b1%95)
* `vsCode` -> `运行` -> `打开配置` -> `弹出选项中选择 PHP` -> `port 改为 9003`
* `vsCode` -> `运行` -> `启动调试` -> `打断点` -> `浏览器刷新页面` -> `在 vsCode 调试`

## 与 `khs1994-docker/lnmp` 项目关系

**远程开发** 启动的容器只提供开发所用的工具链，浏览器访问 PHP 项目与远程开发 **无关**

## 功能

* 可以在 **终端** 直接执行命令

`vsCode` -> `查看` -> `终端` -> `输入所执行的命令，例如 $ php artisan`
