# 生产环境

请首先在 [`开发环境`](../development.md) 中熟悉本项目。

安装 `Docker` 配置 `Docker 加速器`

## 使用一键安装脚本

```bash
$ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh production
```

## 使用 `git clone`

```bash
$ git clone --depth=1 git@github.com:khs1994-docker/lnmp.git
```

## 更新

>生产环境追求稳定，本项目每月第一天发布一个稳定版本，你只需每月第一天 `同步` 本项目即可。

```bash
$ git fetch origin
$ git rebase origin/master
$ ./lnmp-docker.sh production
```
