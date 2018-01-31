# 安装教程

安装 `Docker` 配置 `Docker 加速器`

## 使用一键安装脚本

```bash
$ cd

$ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
```

## 使用 `git clone`

```bash
$ cd

$ git clone --recursive --depth=1 git@github.com:khs1994-docker/lnmp.git
```

## 启动 Demo

```bash
$ cd lnmp

$ ./lnmp-docker.sh development
```

浏览器打开 `127.0.0.1`，看到页面。

## 更新

```bash
$ ./lnmp-docker.sh update

# 强制与上游保持一致

$ ./lnmp-docker.sh update -f
```
