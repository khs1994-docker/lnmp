# Minio

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

* https://docs.minio.io/docs/minio-quickstart-guide.html
* https://github.com/minio/minio

## 配置

### Winodws

在 `.env.ps1` 文件中将 `minio` 包含进来

```bash
$global:LNMP_INCLUDE='nginx','mysql','php7','redis','phpmyadmin',"minio"
```

### Linux、macOS

在 `.env` 文件中将 `minio` 包含进来

```bash
LNMP_INCLUDE="nginx mysql php7 redis phpmyadmin minio"
```

### 配置 NGINX

将 `config/nginx/minio.config` 复制为 `config/nginx/minio.conf`

### 其他配置

在 `.env` 文件中搜索 `MINIO` 进行配置

#### 密钥配置（非常重要）

在 `.env` 进行配置

```bash
MINIO_ACCESS_KEY=khs1994miniokey

MINIO_SECRET_KEY=khs1994miniosecret
```

> 自行修改配置之后，下边命令中的密钥换成你自己设置的！

### 验证

打开 `https://minio.t.khs1994.com`

`khs1994miniokey`

`khs1994miniosecret`

在登录框输入上面密钥即可

## 客户端安装

* https://dl.minio.io/server/minio/release/

选择对应的操作系统，移入 PATH 即可

```bash
$ mc config host add myminio https://minio.t.khs1994.com khs1994miniokey khs1994miniosecret

# 上传文件

$ mc cp /path myminio/mybucket
```

## Laravel

我们知道 minio API 与 AWS s3 兼容，所以我们可以很方便的在 Laravel 中使用 minio

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
    'endpoint' => 'https://minio.t.khs1994.com'
],
```

```php
# 在 minio 中存储一个文件
\Storage::disk('s3')->put('test.txt', '1');
```

* https://docs.minio.io/docs/how-to-use-aws-sdk-for-php-with-minio-server.html
