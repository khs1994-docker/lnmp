# WSL

**在 WSL 执行 Docker CLI 命令，不是在 WSL 运行 Docker 服务端**

## 1. 设置 Windows PATH 变量

```powershell
$ [environment]::SetEnvironmentvariable("Path", "$env:Path;$env:LNMP_PATH\windows;$env:LNMP_PATH\wsl", "User")
```

## 2. 安装 Docker CLI/ docker-compose

WSL 中执行

```bash
$ lnmp-wsl-docker-cli.sh
```

## 3. 设置挂载路径

默认的 WSL 将 C 盘挂载到了 `/mnt/c`，这里修改配置，将 C 盘挂载到 `/c`

* https://raw.githubusercontent.com/khs1994-docker/lnmp/master/wsl/config/wsl.conf

WSL 中执行

```bash
$ sudo vim /etc/wsl.conf

[automount]
enabled = true
root = /
```

## 4. 使用

```bash
$ wsl -- ./lnmp-docker
```

# [WSL2](https://github.com/khs1994-docker/lnmp/blob/master/wsl2/README.DOCKER.md)

由于 Docker 桌面版启动时间较长，经常出现问题（无法启动），本项目支持 WSL2 Docker。
