# Windows 上安装

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

打开 `PowerShell`

```powershell
$ cd $HOME

$ git clone --depth=1 https://github.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --depth=1 https://gitee.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@gitee.com:khs1994-docker/lnmp
```

## 设置环境变量

```powershell
$ [environment]::SetEnvironmentvariable("LNMP_PATH", "${HOME}\lnmp", "User")
```

## 启动 Demo

```powershell
$ cd $HOME

$ cd lnmp

$ ./lnmp-docker.ps1 up
```

> 如果 `PoswerShell` 禁止执行脚本，请以管理员身份执行 `set-ExecutionPolicy Bypass`,之后输入 `Y` 确认。[说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6)

浏览器打开 `127.0.0.1`，看到页面。

## WSL

**在 WSL 执行 Docker CLI 命令，不是在 WSL 运行 Docker 服务端**

### 1. 设置 Windows PATH 变量

```powershell
$ [environment]::SetEnvironmentvariable("Path", "$env:Path;$env:LNMP_PATH\windows;$env:LNMP_PATH\wsl", "User")
```

### 2. 安装 Docker CLI/ docker-compose

WSL 中执行

```bash
$ lnmp-wsl-docker-cli.sh
```

### 3. 设置挂载路径

默认的 WSL 将 C 盘挂载到了 `/mnt/c`，这里修改配置，将 C 盘挂载到 `/c`

* https://raw.githubusercontent.com/khs1994-docker/lnmp/master/wsl/config/wsl.conf

WSL 中执行

```bash
$ sudo vim /etc/wsl.conf

[automount]
enabled = true
root = /
```

### 4. 使用

```bash
$ wsl -- ./lnmp-docker
```

## [WSL2](https://github.com/khs1994-docker/lnmp/blob/19.03/wsl2/README.DOCKER.md)

由于 Docker 桌面版启动时间较长，经常出现问题（无法启动），本项目支持 WSL2 Docker。
