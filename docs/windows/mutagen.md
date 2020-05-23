# mutagen

* https://github.com/mutagen-io/mutagen

# mutagen 解决 Windows Docker(WSL2) 文件性能问题

在 `.env` 文件中设置 `APP_ROOT` 为 `/app`。

```bash
APP_ROOT=/app
```

参照 `mutagen.example.yml` 文件，增加 `mutagen.yml` 文件

```yaml
# mutagen.yml

sync:
  wsl2:
    mode: one-way-safe
    ignore:
      vcs: true
    alpha: "./app"
    beta: "docker://lnmp_mutagen-wsl2_1/app"
    permissions:
      defaultFileMode: 0666
      defaultDirectoryMode: 765
      # defaultOwner: www-data
      # defaultGroup: id:33

beforeCreate:
  - pwsh lnmp-docker.ps1 up mutagen-wsl2

afterTerminate:
  - pwsh lnmp-docker.ps1 stop mutagen-wsl2
```

在 https://github.com/mutagen-io/mutagen/releases 下载，解压后将 `mutagen.exe` `mutagen-agents.tar.gz` 两个文件都放到 `PATH`(例如: `C:\bin`)

```bash
$ mutagen project start
$ mutagen project list
# 停止
$ mutagen project terminate
```

这样 Windows 的 `./app` 同步到 WSL2 的 `/app`，需要挂载项目的容器只需使用 `-v /app:/in-container/app-path` 参数即可。
