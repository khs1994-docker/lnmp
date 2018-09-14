# 命令行补全

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

设置环境变量 `LNMP_PATH` 为本项目的绝对路径(下面以 `/data/lnmp` 为例，实际请替换为你自己的路径)，这样你就可以在任意目录使用本项目的 CLI。

## Bash

```bash
$ vi ~/.bash_profile

export LNMP_PATH=/data/lnmp

export PATH=$LNMP_PATH:$LNMP_PATH/bin:$PATH
```

### Linux

```bash
$ sudo ln -s $LNMP_PATH/cli/completion/bash/lnmp-docker /etc/bash_completion.d/lnmp-docker
```

### macOS

```bash
$ sudo ln -s $LNMP_PATH/cli/completion/bash/lnmp-docker /usr/local/etc/bash_completion.d/lnmp-docker
```

## fish

```bash
$ set -Ux LNMP_PATH /data/lnmp

$ ln -s $LNMP_PATH/cli/completion/fish/lnmp-docker.fish ~/.config/fish/completions/
```

> 删除环境变量 `$ set -Ue LNMP_PATH`

# systemd

systemd 文件位于 `cli/systemd/*`

适用于 `Linux x86_64` 开发环境。

>务必熟悉 `systemd` 之后再执行此项操作。

```bash
$ sudo cp $LNMP_PATH/cli/systemd/lnmp-docker.service /etc/systemd/system/

$ sudo vi /etc/systemd/system/lnmp-docker.service

# 务必自行修改路径为本项目实际路径

$ sudo systemctl daemon-reload

$ sudo systemctl start lnmp-docker

$ sudo systemctl status lnmp-docker

$ sudo systemctl stop lnmp-docker

$ sudo journalctl -u lnmp-docker
```

## 每周清理日志

```bash
$ sudo cp -a $LNMP_PATH/cli/systemd/*-cleanup /etc/systemd/system/

$ sudo vi /etc/systemd/system/lnmp-docker-cleanup.service

# 务必自行修改路径为本项目实际路径

$ sudo systemctl daemon-reload

$ sudo systemctl enable cleanup-lnmp-docker.timer

$ sudo systemctl start cleanup-lnmp-docker.timer

$ systemctl list-timers

$ sudo journalctl -u cleanup-lnmp-docker
```

## 定时备份数据文件

与上方内容类似，这里不再赘述。

## Laravel 队列(Queue)

原理就是执行 `$ docker exec -it PHP_CONTAINER_ID COMMAND`

由 `systemd` 管理

## Laravel 调度器(Schedule)

原理就是执行 `$ docker exec -it PHP_CONTAINER_ID COMMAND`

由 `systemd` 管理

# More Information

* https://www.khs1994.com/linux/systemd.html
