# 命令行补全

## fish

在 `~/.config/fish/config.fish` 文件内写入以下内容。

```bash
set -gx fish_user_paths $fish_user_paths ~/lnmp
```

```bash
$ ln -s ~/lnmp/cli/completion/fish/lnmp-docker.sh.fish ~/.config/fish/completions/
```

>注意请将 `~/lnmp` 替换为本项目实际路径。

## bash

待添加

# systemd

适用于 `Linux`

```bash
$ sudo ln -s /data/lnmp/cli/lnmp-docker.service /usr/lib/systemd/system/

$ sudo systemctl daemon-reload

$ sudo systemctl start lnmp-docker

$ sudo systemctl stop lnmp-docker
```

>注意请将 `/data/lnmp` 替换为本项目实际路径。
