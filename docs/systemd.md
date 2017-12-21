# 命令行补全

## fish

```bash
$ ln -s ~/lnmp/cli/completion/fish/lnmp-docker.sh.fish ~/.config/fish/completions/
```

>注意：请将 `~/lnmp` 替换为本项目实际路径。

## bash

```bash
# Linux

$ ln -s ~/lnmp/cli/completion/bash/lnmp-docker.sh /etc/bash_completion.d/lnmp-docker.sh

# macOS

$ ln -s ~/lnmp/cli/completion/bash/lnmp-docker.sh /usr/local/etc/bash_completion.d/lnmp-docker.sh
```

>注意：请将 `~/lnmp` 替换为本项目实际路径。

# systemd

适用于 `Linux x86_64` 生产环境。

>务必熟悉 `systemd` 之后再执行此项操作。

```bash
$ sudo cp ./cli/systemd/lnmp-docker.service /etc/systemd/system/

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
$ sudo cp -a ./cli/systemd/cleanup-* /etc/systemd/system/

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
