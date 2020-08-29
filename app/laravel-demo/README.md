# Laravel Docker

## 生产环境优化

* 原则上不要把运行中产生的文件放到镜像中，例如日志、用户的上传文件。执行 `$ docker diff CONTAINER_ID` 查看文件变动
* 静态文件放到 CDN。设置 `ASSET_URL`
* 上传的文件放到 **对象存储** 等云端文件系统，例如，`S3`。设置 `FILESYSTEM_DRIVER`

## TODO

* 非 root 用户运行
