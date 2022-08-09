# WSL 相关项目

* https://gitee.com/love_linger/WSL-Launcher

## WSLENV

* https://docs.microsoft.com/zh-cn/windows/wsl/filesystems#share-environment-variables-between-windows-and-wsl-with-wslenv
* https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/

`/p` - 在 WSL/Linux 样式路径与 Win32 路径之间转换路径。
`/l` - 指示环境变量是路径列表。
`/u` - 指示仅当从 Win32 运行 WSL 时，才应包含此环境变量。
`/w` - 指示仅当从 WSL 运行 Win32 时，才应包含此环境变量。

```bash
WSLENV=GOPATH/l:USERPROFILE/w:SOMEVAR/wp
```
