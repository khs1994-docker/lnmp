# Windows 安装本项目

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

打开 `PowerShell`

```bash
$ cd $HOME

$ git clone --depth=1 https://github.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --depth=1 https://gitee.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@gitee.com:khs1994-docker/lnmp
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

* https://github.com/khs1994-docker/lnmp/blob/master/wsl/wsl.conf

默认的 WSL 将 C 盘挂载到了 `/mnt/c`

这里我们修改配置，将 C 盘挂载到 `/c`

```bash
$ wsl

# Windows PATH 变量为 %LNMP_PATH%\windows; %LNMP_PATH%\wsl; %LNMP_PATH\bin

$ lnmp-wsl-docker-cli.sh

$ curl https://raw.githubusercontent.com/khs1994-docker/lnmp/master/wsl/wsl.conf \
  | sudo tee /etc/wsl.conf

# 打开 PowerShell

$ wsl ./lnmp-docker
```
