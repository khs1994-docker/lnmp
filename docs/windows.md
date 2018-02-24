# Windows 安装本项目

```bash
$ git config --global core.autocrlf input

$ git clone --recursive https://github.com/khs1994-docker/lnmp.git

# $ git clone --recursive --depth=1 git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

# $ git clone --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
```

## 启动 Demo

```bash
$ cd lnmp

$ ./lnmp-docker.ps1 development
```

> 如果 `PoswerShell` 禁止执行脚本，请以管理员身份执行 `set-ExecutionPolicy RemoteSigned`,之后输入 `Y` 确认。

浏览器打开 `127.0.0.1`，看到页面。
