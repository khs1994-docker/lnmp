# 命令行补全

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

为了一次性补全 `lnmp-docker.service` 这里将计划任务前缀设置为 `cleanup-*`。

```bash
$ sudo cp -a $LNMP_PATH/cli/systemd/cleanup-* /etc/systemd/system/

$ sudo vi /etc/systemd/system/cleanup-lnmp-docker.service

# 务必自行修改路径为本项目实际路径

$ sudo systemctl daemon-reload

$ sudo systemctl enable cleanup-lnmp-docker.timer

$ sudo systemctl start cleanup-lnmp-docker.timer

$ systemctl list-timers

$ sudo journalctl -u cleanup-lnmp-docker
```

## 定时备份数据文件

与上方内容类似，这里不再赘述。

# More Information

* https://www.khs1994.com/linux/systemd.html
