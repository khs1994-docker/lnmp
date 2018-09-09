# 项目初始化过程

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

是否存在 `.env` 文件，没有将 `.env.example` 复制为 `.env`

是否安装 `docker-compose`

`docker-compose` 是否安装了正确的版本。

如果是 `开发环境`，拉取 `git 子模块`

```bash
$ git submodule update --init --recursive
```

如果是 `生产环境`，载入项目文件、nginx 配置文件（通过 `./scripts/production-init` 脚本载入）。

建立日志文件夹和空白日志文件

初始化完毕之后执行 `docker-compose [-f FILE_NMAE] up -d`
