# WSL2 最佳实践

Docker 或 Kubernetes 运行于 WSL2 ,代码文件夹位于 WSL2 (或者 Windows 挂载路径), 使用 vsCode 进行 [远程开发](README.REMOTE.md)

## %UserProfile%.wslconfig

`config/.wslconfig`

* https://docs.microsoft.com/zh-cn/windows/wsl/wsl-config#configuration-setting-for-wslconfig

## 安装 PHP

```bash
$ ./lnmp-wsl-install php 7.4.3 deb
```
