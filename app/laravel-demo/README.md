# Laravel Docker

如何使用可以参考 `.github/workflows/*.yaml` CI 步骤。

## 生产环境优化

* 原则上不要把运行中产生的文件放到镜像中，例如日志(stderr)、用户的上传文件(s3)。执行 `$ docker diff CONTAINER_ID` 查看文件变动
* 前端静态文件放到 CDN。设置 `ASSET_URL`
* 不要在 config 以外的地方调用 `env()` 函数，运行 `config:cache` 以后该函数永远返回 `null`

## TODO

## ui auth + mix version

`resources/views/layouts/app.blade.php` `asset()` 函数替换为 `mix()`
