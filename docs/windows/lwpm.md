# Windows 包管理工具

正如 macOS 上的 `brew`、Linux 上的 `apt` `yum` `dnf`，本项目提供了 `lnmp-windows-pm.ps1` 这一包管理工具，让开发者使用 `CLI` 快速安装开发软件。

```bash
$ lnmp-windows-pm.ps1 install go
```

执行以上命令可以安装 `go`。执行 `$ lnmp-windows-pm.ps1 list` 查看可供安装的软件。

## 安装测试版软件

```bash
$ lnmp-windows-pm.ps1 install go --pre
```

只需加上 `--pre` 参数即可安装测试版软件。
