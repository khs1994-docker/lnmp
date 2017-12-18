# 命令行补全

## fish

>务必熟悉 `fish` shell 之后再执行此项操作。

在 `~/.config/fish/config.fish` 文件内写入以下内容。

```bash
set -gx fish_user_paths $fish_user_paths ~/lnmp
```

```bash
$ ln -s ~/lnmp/cli/completion/fish/lnmp-docker.sh.fish ~/.config/fish/completions/
```

>注意：请将 `~/lnmp` 替换为本项目实际路径

## bash

>务必熟悉 `bash` shell 之后再执行此项操作。

在 `~/.bash_profile` 写入以下内容。

```bash
export PATH=~/lnmp:$PATH
```

```bash
# Linux

$ ln -s ~/lnmp/cli/completion/bash/lnmp-docker.sh /etc/bash_completion.d/lnmp-docker.sh

# macOS

$ ln -s ~/lnmp/cli/completion/bash/lnmp-docker.sh /usr/local/etc/bash_completion.d/lnmp-docker.sh
```

>注意：请将 `~/lnmp` 替换为本项目实际路径

# systemd

适用于 `Linux x86_64` 生产环境。

>务必熟悉 `systemd` 之后再执行此项操作。

```bash
$ cp /data/lnmp/cli/systemd/lnmp-docker.service /etc/systemd/system/

$ sudo vi /etc/systemd/system/lnmp-docker.service

# 自行修改路径为本项目实际路径

$ sudo systemctl daemon-reload

$ sudo systemctl start lnmp-docker

$ sudo systemctl stop lnmp-docker
```

>注意：请将 `/data/lnmp` 替换为本项目实际路径
