# [lrew](https://github.com/lrew)

> khs1994-docker/lnmp 包管理工具，支持推送到 Docker Registry。

* https://hub.docker.com/u/lrewpkg

macOS 有 `brew` 包管理工具，khs1994-docker/lnmp 包管理工具称为 `lrew`。`lrew` 实现了对 khs1994-docker/lnmp 项目的扩展，让用户可以方便的增加某个软件。

## 修改配置

你可以通过以下方式启用 `example` 包（假设 `example` 包提供了 `example` 服务）。若在 `lrew` 目录下没找到你所需要的包，你可以参照下一小节开发一个包或者在 https://hub.docker.com/u/lrewpkg 寻找一个包。

编辑 `.env` 文件，将 `example` 加入到以下变量中，例如

```bash
LREW_INCLUDE="minio example"

LNMP_SERVICES="nginx mysql php7 redis example"
```

### 启动

```bash
$ lnmp-docker up
```

## 开发一个包（开发者）

> **这个项目能不能增加 xxx 软件，可以！** 下文用 `example` 代替 `xxx` 软件

```bash
$ lnmp-docker lrew-init example
```

修改 `vendor/lrew-dev/example` 内的文件。

根据上方 `修改配置` 一节，测试项目文件。

之后推送到 GitHub，并发布到 Docker Hub。

* 示例：https://github.com/lrew/lrew-etcd

> 可以参考 `lrew` 文件夹中的示例项目

## 添加一个包，并使用所提供的服务

你可以使用已发布到 [Docker Hub](https://hub.docker.com/u/lrewpkg) 的包所提供的服务。

```bash
$ lnmp-docker lrew-add example
```

根据上方 `修改配置` 一节进行配置，之后启动

```bash
$ ./lnmp-docker up
```

## 优先级(开发者)

`vendor/lrew-dev` 优先级大于 `vendor/lrew`。
