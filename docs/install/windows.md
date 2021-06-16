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

> 如果 `PowerShell` 禁止执行脚本，请以管理员身份运行 `PowerShell` 并执行 `set-ExecutionPolicy Bypass`,之后输入 `Y` 确认。[说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_execution_policies)

```powershell
#　禁止执行脚本的提示
PS C:\Users\90621\lnmp> .\lnmp-docker
.\lnmp-docker : File C:\Users\90621\lnmp\lnmp-docker.ps1 cannot be loaded because running scripts is disabled on this s
ystem. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ .\lnmp-docker
+ ~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

```powershell
＃ 解决方法
PS C:\Windows\system32> set-ExecutionPolicy Bypass

Execution Policy Change
The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose
you to the security risks described in the about_Execution_Policies help topic at
https:/go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the execution policy?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): Y（输入Y）
```

浏览器打开 `127.0.0.1`，看到页面。
