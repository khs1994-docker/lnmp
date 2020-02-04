# [Windows 包管理工具 lwpm](https://github.com/khs1994-docker?utf8=✓&q=lwpm&type=&language=)

正如 `macOS` 上的 `brew`、Linux 上的 `apt` `yum` `dnf`，本项目提供了 `lnmp-windows-pm.ps1` 这一包管理工具，让开发者快速在 `Windows` 安装开发软件。

```bash
$ lnmp-windows-pm.ps1 install go
```

执行以上命令可以安装 `go`。执行 `$ lnmp-windows-pm.ps1 list` 查看可供安装的软件。

## 安装测试版软件

只需加上 `--pre` 参数即可安装测试版软件。

```bash
$ lnmp-windows-pm.ps1 install go --pre
```

## 开发一个包(开发者)

本项目提供了一些常用的包，你也可以自己开发一个包，供用户安装某个软件。

```bash
$ lnmp-windows-pm.ps1 init example
```

编辑 `~/lnmp/vendor/lwpm-dev/example` 文件夹中的文件。

编辑好之后推送到 GitHub，并发布到 composer。

* 示例: https://github.com/khs1994-docker/lwpm-openjdk

## 添加一个包，并安装软件

在 https://packagist.org/packages/lwpm/ 寻找一个包，并使用以下命令添加包并安装包所提供的软件：

```bash
$ cd ~/lnmp

$ lnmp-windows-pm.ps1 add example

$ lnmp-windows-pm.ps1 install example
```

## 优先级(开发者)

`vendor/lwpm-dev` 优先级大于 `vendor/lwpm`

## 注册 Windows 服务

请以管理员打开 `powershell` 执行下面的命令

```powershell
$ lnmp-windows-pm.ps1 install-service minio "C:/bin/minio","server","$HOME/minio" C:/logs/minio.log
```

移除服务

```bash
$ lnmp-windows-pm.ps1 remove-service minio
```
