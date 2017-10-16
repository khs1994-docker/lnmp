# 初始化

是否安装 `docker-compose`

是否存在 `.env` 文件，没有将 `.env.example` 复制为 `.env`

如果是 `开发环境`，拉取 `git 子模块`

```bash
$ git submodule update --init --recursive
```

如果是 `生产环境`，载入项目文件、nginx 配置文件

建立日志文件夹和空白日志文件
