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

编辑好之后推送到 docker hub 或者其他私有 docker registry(通过 `$env:LWPM_DOCKER_REGISTRY="docker-registry.domain.com"` 设置)

```bash
# $ $env:LWPM_DOCKER_REGISTRY="docker-registry.domain.com"

$ $env:LWPM_DOCKER_USERNAME="your_username"
$ $env:LWPM_DOCKER_PASSWORD="your_password"

$ lnmp-windows-pm.ps1 push docker_registry_username/example
```

* 示例: https://github.com/khs1994-docker/lwpm-openjdk

## 添加一个包，并安装软件

在 https://hub.docker.com/u/lwpm 寻找一个包，并使用以下命令添加包并安装该包所提供的软件：

```bash
$ cd ~/lnmp

# $ $env:LWPM_DOCKER_REGISTRY="docker-registry.domain.com"

# $ $env:LWPM_DOCKER_USERNAME="your_username"
# $ $env:LWPM_DOCKER_PASSWORD="your_password"

$ lnmp-windows-pm.ps1 add example

$ lnmp-windows-pm.ps1 install example
```

## 优先级(开发者)

`vendor/lwpm-dev` 大于 `vendor/lwpm` 大于 `默认自带包（windows/lnmp-windows-pm-repo）`

## Windows 服务

**注册（新增）服务**

请以 **管理员** 打开 `powershell` 执行下面的命令(这里以 minio 为例)

```powershell
$ lnmp-windows-pm.ps1 install-service minio "C:/bin/minio","server","$HOME/minio" C:/logs/minio.log
```

**移除服务**

```powershell
$ lnmp-windows-pm.ps1 remove-service minio
```

**启动服务**

```powershell
$ lnmp-windows-pm.ps1 start-service minio
```

**停止服务**

```powershell
$ lnmp-windows-pm.ps1 stop-service minio
```

**重启服务**

```powershell
$ lnmp-windows-pm.ps1 restart-service minio
```

## 开发者

**dist** 从软件源下载文件并打包

```bash
 package
 |__dist
    |
    |__os-arch
       |
       |__dist_file-os-arch
    |__linux-amd64
       |
       |__dist_file-linux-amd64
    |__linux-arm
       |
       |__dist_file-linux-arm
 |__lwpm.json
```

**add --platform** 获取所有架构的文件（适用于从 docker hub 获取文件）

```bash
 package
 |__dist
    |
    |__dist_file-os-arch
    |__dist_file-linux-amd64
    |__dist_file-linux-arm
 |__lwpm.json
```

**push** 推送到 Docker Registry

## lwpm.json 支持的变量

* `${VERSION}`

* `$filename` 下载的文件

* `$env:lwpm_os` (e.g. linux)
* `$env:lwpm_architecture` (e.g. amd64)

* `$env:LWPM_UNAME_S` (e.g. Linux)
* `$env:LWPM_UNAME_M` (e.g. x86_64)

* `$_IsWindows` `$_IsMacOS` `$_IsLinux` 指当前处理的目标平台（注意与 `$IsWindows` 等变量的区别，这些变量指当前 powershell 运行的平台 ）

* `$env:LWPM_PKG_ROOT`(lwpm.json 所在文件夹)

## lwpm.json 支持的部分函数

* `printError` `printInfo` `PrintWarning`
* `_cleanup`
* `_unzip`
* `_mkdir`
* `start-process file.exe -wait`
* `Get-SHA256` `Get-SHA384` `Get-SHA512`
