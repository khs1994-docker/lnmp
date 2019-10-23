# vsCode Developing inside a Container(vsCode 远程开发)

* https://code.visualstudio.com/docs/remote/containers

## 说明

`工具链(PHP)` `vsCode Server` 位于容器, `vsCode` 位于本地

## 准备

**项目文件夹**

1. 将 `.devcontainer` `docker-workspace.yml` 复制到 PHP 项目文件夹根目录,并作适当调整(搜索 `fix me`)

**工具准备**

2. `vsCode` 安装 `Remote Development` 扩展

3. 适当调大 Docker 桌面版内存(建议 `4GB`)

4. 启动 `khs1994-docker/lnmp`

```bash
$ ./lnmp-docker up
```

## vsCode 扩展

* `felixfbecker.php-pack`

## 步骤

1. 打开 `vsCode`(`$ code`)

2. Press `F1`, select `Remote-Containers: Open Folder in Container...`. 选择项目文件夹(包含 `.devcontainer`, `docker-workspace.yml`).

3. 扩展需要在 `远程` 安装(以前安装过的扩展在 **远程** 重新安装)

4. 首次使用,需要初始化,请耐心等待

5. 修改 `.devcontainer` `docker-workspace.yml` 之后重新载入. Press `F1`, select `Remote-Containers: Rebuild Container`

## 依赖管理(执行 composer 命令)

> `workspace` 不包含 `composer`,我们必须使用新的 `service` 运行 `composer` 命令

为了提高性能,项目的 `vendor` 文件夹位于 **数据卷** 中,首次使用必须重新安装依赖.

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

* 端口: 9001
* 远程地址: 192.168.199.100(宿主机 IP)

以上两项到 `khs1994-docker/lnmp` 配置

* [浏览器安装 `xdebug` 扩展](https://docs.lnmp.khs1994.com/xdebug.html#%e6%b5%8f%e8%a7%88%e5%99%a8%e6%89%a9%e5%b1%95)
* `vsCode` -> `调试` -> `打开配置` -> `port 改为 9001`
* `vsCode` -> `调试` -> `启动调试` -> `打断点` -> `浏览器刷新页面` -> `在 vsCode 调试`

## 与 `khs1994-docker/lnmp` 项目关系

**远程开发** 启动的容器只提供开发所用的工具链,浏览器访问 PHP 项目与远程开发 **无关**。

## 功能

* 可以在 **终端** 直接执行命令(`vsCode` -> `查看` -> `终端` -> 右上角 `+` 号) `$ php artisan`
