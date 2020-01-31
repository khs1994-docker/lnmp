# Helm 私有服务器

## 打包

```bash
$ cd nginx-php

$ helm package . [--dependency-update]

# $ helm install lnmp-nginx-php nginx-php-0.0.1.tgz --set service.type=NodePort

# index.yaml
$ helm repo index . --merge ../repo/index.yaml --url https://storage.khs1994.com/charts

$ cp index.yaml *.tgz ../repo/
```

## 私有服务器

**以下地址为示例地址，请勿直接使用。**

### 使用 Minio 搭建对象存储

* https://github.com/khs1994-docker/lnmp/blob/master/docs/minio.md

### 上传文件

```bash
# 配置 minio 客户端 mc
$ mc config host add myminio https://storage.khs1994.com minioadmin minioadmin

# 新建 bucket
$ mc mb myminio/charts

# 设置权限
$ mc policy download myminio/charts

$ cd repo

$ mc cp index.yaml myminio/charts

$ mc cp nginx-php-0.0.1.tgz myminio/charts
```

### helm 增加 repo

```bash
$ helm repo add khs1994-docker https://storage.khs1994.com/charts

$ helm install lnmp-nginx-php khs1994-docker/nginx-php --dry-run --debug --set KEY=VALUE
```

## More Information

* https://blog.csdn.net/u013289746/article/details/80605857
