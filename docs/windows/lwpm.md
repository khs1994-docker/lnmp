# Windows 包管理工具

正如 macOS 上的 `brew`、Linux 上的 `apt` `yum` `dnf`，本项目提供了 `lnmp-windows-pm.ps1` 这一包管理工具，让开发者使用 `CLI` 快速安装开发软件。

```bash
$ lnmp-windows-pm.ps1 install go
```

执行以上命令可以安装 `go`。执行 `$ lnmp-windows-pm.ps1 list` 查看可供安装的软件。

## 安装测试版软件

只需加上 `--pre` 参数即可安装测试版软件。

```bash
$ lnmp-windows-pm.ps1 install go --pre
```

## 新增一个包(开发者)

本项目提供了一些常用的包，你也可以自己开发一个包，供用户安装某个软件。

```bash
$ lnmp-windows-pm.ps1 init example
```

编辑 `~/lnmp/vendor/lwpm-dev/example` 文件夹中的文件。

编辑好之后推送到 GitHub，并发布到 composer。

* 示例: https://github.com/khs1994-docker/lwpm-openjdk

## 添加一个包，并安装软件

```bash
$ cd ~/lnmp

$ lnmp-windows-pm.ps1 add example

$ lnmp-windows-pm.ps1 install example
```
