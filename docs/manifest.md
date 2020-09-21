# 构建支持多种架构的 Docker 镜像

**推荐使用 [`$ docker buildx build`](buildx.md)命令**

```bash
# 事先请登录 Docker Hub
# 镜像列表中的镜像请事先构建并推送到 Docker Hub
# docker manifest create PULL名字 [镜像列表]
$ docker manifest create khs1994/php:7.3.8-fpm-alpine \
      khs1994/php:7.3.8-fpm-alpine \
      khs1994/arm32v7-php:7.3.8-fpm-alpine \
      khs1994/arm64v8-php:7.3.8-fpm-alpine

# docker manifest annotate PULL名字 镜像名 --os 系统  --arch 架构
$ docker manifest annotate khs1994/php:7.3.8-fpm-alpine \
      khs1994/php:7.3.8-fpm-alpine \
      --os linux --arch amd64

$ docker manifest annotate khs1994/php:7.3.8-fpm-alpine \
      khs1994/arm64v8-php:7.3.8-fpm-alpine \
      --os linux --arch arm64

# 推送
$ docker manifest push khs1994/php:7.3.8-fpm-alpine
```

在 arm 架构中 pull `khs1994/php:7.3.8-fpm-alpine` 实际 pull 的是 `khs1994/arm64v8-php:7.3.8-fpm-alpine`

这样在多种架构中可以很方便的进行 pull，避免通过判断架构 pull 不同的镜像，极大简化了镜像 pull。

```bash
$ docker manifest inspect php:7.3.8-fpm-alpine
```

```json
{
   "schemaVersion": 2,
   "mediaType": "application/vnd.docker.distribution.manifest.list.v2+json",
   "manifests": [
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 2411,
         "digest": "sha256:c61eb690932ead740308e94d3f19ed51642df60a85f2bbbec1adfece7aec640a",
         "platform": {
            "architecture": "amd64",
            "os": "linux"
         }
      },
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 2411,
         "digest": "sha256:590971cfec7c3008c91174ba57ab8e1f73905e9f613ec06bfd6c0d77ac4923d5",
         "platform": {
            "architecture": "arm",
            "os": "linux",
            "variant": "v6"
         }
      },
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 2411,
         "digest": "sha256:2e87c91f00c61af79f2c9e3cd7e8656aae277c1e12b69e1afcda82f467a7d521",
         "platform": {
            "architecture": "arm",
            "os": "linux",
            "variant": "v7"
         }
      },
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 2411,
         "digest": "sha256:0ea6abb7a9f7ea8f1d4ad1214a4eacb2865497ff579c4e999425fcce0e8a47af",
         "platform": {
            "architecture": "arm64",
            "os": "linux",
            "variant": "v8"
         }
      },
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 2411,
         "digest": "sha256:1493cdd3ae9526b8ca9c6b5fad2a1f3d515fa621e1bbc222f8104bc35f492723",
         "platform": {
            "architecture": "386",
            "os": "linux"
         }
      },
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 2411,
         "digest": "sha256:9a1d423f7657bc88af237c10a78c7f06fc115349a0b2364e212a32cde88825d6",
         "platform": {
            "architecture": "ppc64le",
            "os": "linux"
         }
      }
   ]
}
```

## 示例

请查看 `scripts/arm-build.sh`

## More Information

* https://blog.csdn.net/dev_csdn/article/details/79138424

```json
// manifest list 内容的 sha256 可作为 image digest
// manifest (如下所示)内容的 sha256 可作为 image digest
{
   "schemaVersion": 2,
   "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
   "config": {
      "mediaType": "application/vnd.docker.container.image.v1+json",
      "size": 1510,
      // image id
      "digest": "sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b"
   },
   "layers": [
      {
         "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
         "size": 2529,
         "digest": "sha256:0e03bdcc26d7a9a57ef3b6f1bf1a210cff6239bff7c8cac72435984032851689"
      }
   ]
}
```
