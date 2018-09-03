# Minio

* https://docs.minio.io/docs/minio-quickstart-guide.html
* https://github.com/minio/minio

## 配置

### Winodws

在 `.env.ps1` 文件中将 `minio` 包含进来

```bash
$global:DEVELOPMENT_INCLUDE='nginx','mysql','php7','redis','phpmyadmin',"minio"
```

### Other

在 `.env` 文件中将 `minio` 包含进来

```bash
DEVELOPMENT_INCLUDE="nginx mysql php7 redis phpmyadmin minio"
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
