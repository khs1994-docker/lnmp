# vsCode Developing inside a Container

* https://code.visualstudio.com/docs/remote/containers

## 说明

`工具链(PHP)` `vsCode Server` 位于容器, 编辑器位于本地

## 准备

**项目文件夹**

将 `.devcontainer` `docker-workspace.yml` 复制到 PHP 项目文件夹根目录,并作适当调整(搜索 `fix me`)

**工具准备**

`vsCode` 安装 `Remote Development` 扩展

适当调大 Docker 桌面版内存(建议 `4GB`)

启动 `khs1994-docker/lnmp`

```bash
$ ./lnmp-docker up
```

## 步骤

打开 `vsCode`

Press `F1`, select `Remote-Containers: Open Folder in Container...`. 选择项目文件夹(包含 .devcontainer, docker-workspace.yml)).

扩展需要在 `远程` 安装(以前安装过的扩展在 远程 重新安装)

首次使用,需要初始化,请耐心等待

修改 `.devcontainer` `docker-workspace.yml` 之后重新载入. Press `F1`, select `Remote-Containers: Rebuild Container...`

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

或者执行

```bash
$ lnmp-docker composer install | update | require XXX
```

## Xdebug

## 功能

* 可以在 **终端** 直接执行命令(查看 -> 终端) `$ php artisan`
