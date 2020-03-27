# WSL2 最佳实践

Docker 或 Kubernetes 运行于 WSL2 ,代码文件夹位于 WSL2 (或者 Windows 挂载路径), 使用 vsCode 进行 [远程开发](README.REMOTE.md)

## Docker

```bash
$ sudo service docker start

$ ps aux
```

## 初始化

```bash
$ cd ~/lnmp/wsl

$ wsl

$ ./lnmp-wsl-init
```

## %UserProfile%.wslconfig

`config/.wslconfig`

* https://github.com/MicrosoftDocs/WSL/releases/tag/18947

## 安装 PHP

```bash
$ ./lnmp-wsl-install php 7.4.3 deb
```
