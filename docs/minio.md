# Minio

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

* https://docs.min.io/docs/minio-quickstart-guide.html
* https://github.com/minio/minio

## 配置

在 `.env` 文件中将 `minio` 包含进来

```bash
LNMP_SERVICES="nginx mysql php7 redis minio"
LREW_INCLUDE="minio pcit"
```

### 配置 NGINX

将 `config/nginx/minio.config` 复制为 `config/nginx/minio.conf`

### 其他配置

自行在 `.env` 文件添加 [minio](https://github.com/khs1994-docker/lnmp/blob/master/lrew/minio/.env.compose) 相关变量

#### 密钥配置（非常重要）

在 `.env` 进行配置

```bash
MINIO_ACCESS_KEY=minioadmin

MINIO_SECRET_KEY=minioadmin
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
    'endpoint' => 'https://minio.t.khs1994.com'
],
```

```php
# 在 minio 中存储一个文件
\Storage::disk('s3')->put('test.txt', '1');
```

* https://docs.minio.io/docs/how-to-use-aws-sdk-for-php-with-minio-server.html
