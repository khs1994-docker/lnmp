# PowerShell

* https://www.pstips.net/
* https://docs.microsoft.com/en-us/powershell/

## write-debug

```powershell
PS> $DebugPreference

SilentlyContinue
# 默认不显示 debug 信息

# 更改为如下值，则会显示
PS> $DebugPreference = "Continue"

# 也可以加上 -Debug，也会显示
PS> write-debug 1 -Debug
```

## write-information

默认不会显示，加上 `-InformationAction Continue`

```powershell
PS> $InformationPreference
SilentlyContinue

PS> Write-Information -MessageData "Got your features!" -InformationAction Continue
```

## write-output(echo) / write-host

`write-host` 输出到终端，结果不能重定向到文件，`write-output` 可以。

## $ErrorActionPreference

> 可以设置为这些值：SilentlyContinue,Stop,Continue,Inquire,Ignore,Suspend,Break

默认值为 `Continue`，当执行错误时，将继续执行。

改为 `stop`，当执行错误时，不再继续执行。（相当于 bash 的 `set -e`）

改为 `SilentlyContinue` 不会显示错误信息。

## 输出错误到文件

```powershell
PS> write-error 1 2>&1 error.txt
```

## profiles

* https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles

```bash
$ echo $PROFILE
```

> 相当于 `~/.bashrc`

## ExperimentalFeature

```powershell
$ ExperimentalFeature
$ ExperimentalFeature -?

$ Enable-ExperimentalFeature PSCommandNotFoundSuggestion
```

## powershellget

* https://www.pstips.net/share-script-on-powershell-gallery.html

```bash
$ Get-Command -Module PowerShellGet

$ Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
```

## 版本号对比

```powershell
$ [version]"1.1.0" -ge [version]"1.0.0"

True
```

## WMF

* https://www.2cto.com/net/201701/585277.html
