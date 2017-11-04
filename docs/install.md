# 安装教程

安装 `Docker` 配置 `Docker 加速器`

## 使用一键安装脚本

```bash
$ curl -fsSL lnmp.khs1994.com -o lnmp.sh ; sh lnmp.sh
```

## 使用 `git clone`

```bash
$ git clone --recursive -b dev --depth=1 git@github.com:khs1994-docker/lnmp.git
```

## 更新

```bash
$ git fetch origin
$ git rebase origin/master
$ ./lnmp-docker.sh development
```
