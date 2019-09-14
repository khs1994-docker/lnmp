# PowerShell

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

## $ErrorActionPreference

默认值为 `Continue`，当执行错误时，将继续执行。

改为 `stop`，当执行错误时，不再继续执行。（相当于 bash 的 `set -e`）

改为 `SilentlyContinue` 不会显示错误信息。

## 输出错误到文件

```powershell
PS> write-error 1 2>&1 error.txt
```
