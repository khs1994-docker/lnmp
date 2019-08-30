# lrew

> khs1994-docker/lnmp 包管理工具。

macOS 有 `brew` 包管理工具，khs1994-docker/lnmp 包管理工具称为 `lrew`。`lrew` 实现了对 khs1994-docker/lnmp 项目的扩展，提供了以下功能。

## 增加服务

> **这个项目能不能增加 xxx 软件，可以！** 下文用 `example` 代替 `xxx` 软件

```bash
$ lnmp-docker init example
```

修改 `vendor/lrew-dev/example` 内的文件。

根据下方 `修改配置` 一节，测试项目文件。

之后推送到 GitHub，并发布到 composer。

* 示例：https://github.com/khs1994-docker/lrew-harbor

> 可以参考 `lrew` 文件夹中的示例项目

## 增加已有服务

你可以使用已发布到 [composer](https://packagist.org/packages/lrew/) 的服务。

```bash
$ lnmp-docker add example
```

## 修改配置

### Linux、macOS

编辑 `.env` 文件，将 `example` 加入到以下变量中，例如

```bash
LREW_INCLUDE="etcd example"

LNMP_SERVICES="nginx mysql php7 redis phpmyadmin example"
```

### Windows

编辑 `.env.ps1` 文件，将 `example` 加入到以下变量中，例如

```bash
$global:LREW_INCLUDE="etcd","example"

$global:LNMP_SERVICES='nginx','mysql','php7','redis','phpmyadmin','example'
```

### 启动

```bash
$ lnmp-docker up
```
