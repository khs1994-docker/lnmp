# 安装教程

## 使用一键安装脚本

```bash
$ cd

$ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
```

## 使用 `git clone`

```bash
$ cd

$ git clone --depth=1 --recursive https://github.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 --recursive git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --depth=1 --recursive https://code.aliyun.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 --recursive git@code.aliyun.com:khs1994-docker/lnmp.git
```

## 启动 Demo

```bash
$ cd lnmp

$ ./lnmp-docker up
```

浏览器打开 `127.0.0.1`，看到页面。

## MySQL 默认 ROOT 密码

`mytest`

## 更新

```bash
$ ./lnmp-docker update

# 强制与上游保持一致

$ ./lnmp-docker update -f
```
