# Minio

* https://docs.min.io/docs/minio-quickstart-guide.html
* https://github.com/minio/minio

## 配置

在 `.env` 文件中将 `minio` 包含进来

```bash
LNMP_SERVICES="nginx mysql php8 redis minio"
LREW_INCLUDE="minio pcit"
```

### 配置 NGINX

将 `config/nginx/demo.config/minio.config` 复制为 `config/nginx/minio.conf`

### 其他配置

自行在 `.env` 文件添加 [minio](https://github.com/khs1994-docker/lnmp/blob/master/lrew/minio/.env.compose) 相关变量

#### 密钥配置（非常重要）

在 `.env` 进行配置

```bash
MINIO_ROOT_USER=minioadmin

MINIO_ROOT_PASSWORD=minioadmin
```

> 自行修改配置之后，下边命令中的密钥换成你自己设置的！

#### 启动

```bash
$ ./lnmp-docker up
```

### 验证

打开 `https://minio.t.khs1994.com`

`minioadmin`

`minioadmin`

在登录框输入上面密钥即可

## 客户端安装(mc)

* https://dl.minio.io/server/minio/release/
* https://dl.minio.io/client/mc/release/

选择对应的操作系统，移入 PATH 即可

> 官网直接下载可能较缓慢。

### Windows 安装

```powershell
$ lnmp-windows-pm.ps1 install minio
```

### macOS 安装

```bash
$ brew install minio/stable/minio

$ brew install minio/stable/mc
```

### 命令

```bash
# 启动
$ minio server /home/shared
```

```bash
$ mc config host add minio https://minio.t.khs1994.com minioadmin minioadmin

# 上传文件

$ mc cp /path minio/mybucket
```

## Laravel

minio API 与 AWS s3 兼容，所以可以很方便的在 Laravel 中使用 minio

```bash
$ composer require league/flysystem-aws-s3-v3
```

`config/filesystems.php` 中进行如下设置。

```php
's3' => [
    'driver' => 's3',
    'key' => env('AWS_ACCESS_KEY_ID'),
    'secret' => env('AWS_SECRET_ACCESS_KEY'),
    'region' => env('AWS_DEFAULT_REGION', 'us-east-1'), // 随便填一个
    'bucket' => env('AWS_BUCKET'), // 使用前先在 minio web 界面新建一个 bucket
    'use_path_style_endpoint' => true, // 必须加上
    'endpoint' => env('MINIO_ENDPOINT','https://minio.t.khs1994.com')
],
```

```php
# 在 minio 中存储一个文件
\Storage::disk('s3')->put('test.txt', '1');
```

* https://docs.minio.io/docs/how-to-use-aws-sdk-for-php-with-minio-server.html

## 版本支持

* 历史版本下载 https://dl.min.io/server/minio/release/windows-amd64/archive/

* `RELEASE.2022-05-26T05-48-41Z` 该版本及之前版本新建 bucket 仍然使用 **legacy FS mode**

* `RELEASE.2022-06-02T02-11-04Z` 该版本及之后版本(不存在数据)新建 bucket 使用新模式，旧版本可以升级
> 可以通过以下方法使用旧模式
> https://www.funkypenguin.co.nz/blog/how-to-run-minio-in-fs-mode-again/

```bash
# /path-to-existing-data/.minio.sys/
{"version":"1","format":"fs","id":"avoid-going-into-snsd-mode-legacy-is-fine-with-me","fs":{"version":"2"}}
```

* `RELEASE.2022-10-24T18-35-07Z` 该版本是最后一个兼容 **legacy FS mode** 的版本。

* `RELEASE.2022-10-29T06-21-33Z` 该版本不再兼容 **legacy FS mode**(相关代码已经删除)

```bash
ERROR Unable to use the drive /data: Drive /data: found backend type fs, expected xl or xl-single:
```

* https://blog.min.io/deprecation-of-the-minio-gateway/?ref=docs
* https://min.io/docs/minio/linux/operations/install-deploy-manage/migrate-fs-gateway.html


```
Deprecation of the MinIO gateway

on S3 24 February 2022

MinIO is deprecating the gateway and will be completely removed in six months. This should not come as a surprise, we began informing the community in 2020 and have steadily removed unpopular gateways. In the last ten months, MinIO has only made bug fixes.

The community can continue to use older versions of MinIO past that date. We also encourage any volunteers to step up and maintain open source forks as standalone projects. All modifications and improvements must also be released under the GNU AGPL v3 license.

Existing commercial customers of MinIO will be supported for as long as necessary.

The reasoning as to why we are deprecating the gateway is relatively straightforward.

We introduced the gateway feature early on to help make the S3 API ubiquitous. From legacy POSIX-based SAN/NAS systems to modern cloud storage services, the different MinIO gateway modules brought S3 API compatibility where it did not exist previously. The primary objective was to provide sufficient time to port the applications over a modern cloud-native architecture. In the gateway mode, MinIO ran as a stateless proxy service, performing inline translation of the object storage functions from the S3 API to their corresponding equivalent backend functions. At any given time, the MinIO gateway service could be turned off and the only loss was S3 compatibility. The objects were always written to the backend in their native format, be it NFS or Azure Blob, or HDFS.

Implementing different gateways proved to be more challenging than the server mode because it was easier to implement the S3 capabilities in our native erasure-coded backend as compared to competitors' products. The gateway was and still is a great implementation. It worked as advertised, was lightweight and non-intrusive.

So why are we depreciating it?

The answer has two parts. First, the MinIO gateway achieved its primary purpose of driving the S3 API's ubiquity.  The goal has been achieved. S3 API is the de facto standard for storage and has made object storage the storage class of the cloud and of Kubernetes. As a result, the gateway merely perpetuates legacy technologies. Gateway users have had years to transition; it is time to let the legacy technologies go.

Second, the S3 API has evolved considerably since we started, and what began as inline translation morphed into something much more. Critical S3 capabilities like versioning, bucket replication, immutability/object locking, s3-select, encryption, and compression couldn’t be supported in the gateway mode without introducing a proprietary backend format. It would defeat the purpose of the gateway mode because the backend could no longer be read directly without the help of the gateway service. The backends would merely act as storage media for the gateway and you might as well run MinIO in server mode. Thus it became a compromise that MinIO no longer wanted to engage in. This meant it was time for us to let go.

The class of problems faced by our customers today is suited for the capabilities of the full MinIO Server implementation. In fact, among our commercial customers, the gateway-only usage is less than 2%. Accordingly, we are investing in taking the MinIO server to the next level and so we are deprecating the gateway functionality.

If you have any questions, feel free to head over to our Slack channel and engage the team. We are happy to answer any questions you might have. If the questions are of a commercial nature, shoot us an email at hello@min.io and we will be sure to respond.
```
