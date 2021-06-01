# Windows 上安装

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

> 如果 `PoswerShell` 禁止执行脚本，请以管理员身份执行 `set-ExecutionPolicy Bypass`,之后输入 `Y` 确认。[说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_execution_policies)

浏览器打开 `127.0.0.1`，看到页面。
