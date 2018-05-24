# Windows 安装本项目

打开 `PowerShell`

```bash
$ cd $HOME

# $ git config --global core.autocrlf input

$ git clone --recursive https://github.com/khs1994-docker/lnmp.git

# $ git clone --recursive --depth=1 git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

# $ git clone --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
```

## 设置环境变量

```bash
$ [environment]::SetEnvironmentvariable("LNMP_PATH", "$env:HOME/lnmp", "User");
```

## 启动 Demo

```bash
$ cd $HOME

$ cd lnmp

$ ./lnmp-docker.ps1 up
```

> 如果 `PoswerShell` 禁止执行脚本，请以管理员身份执行 `set-ExecutionPolicy RemoteSigned`,之后输入 `Y` 确认。

浏览器打开 `127.0.0.1`，看到页面。

## MySQL 默认 ROOT 密码

`mytest`

## Use WSL

```bash
$ bash

# Windows PATH 变量为 %LNMP_PATH%\windows; %LNMP_PATH%\wsl; %LNMP_PATH\bin

$ lnmp-wsl-docker-cli.sh

$ sudo ln -sf /mnt/c /C

$ cd /C/Users/YOUR_USERNAME/lnmp

$ ./lnmp-docker.sh
```
