# Composer

## 忽略相关的参数

```bash
$ composer install \
    --no-plugins \
    --no-interaction \
    --ignore-platform-reqs \
    --no-scripts
```

## 国内镜像

### 推荐使用

```bash
$ composer config -g repos.packagist composer https://packagist.mirrors.sjtug.sjtu.edu.cn

$ composer config -g repos.packagist composer https://php.cnpkg.org

$ composer config -g repos.packagist composer https://mirrors.aliyun.com/composer/

$ composer config -g repos.packagist composer https://mirrors.huaweicloud.com/repository/php/

$ composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/
```

### 其他

```
$ composer config -g repos.packagist composer https://packagist.phpcomposer.com

$ composer config -g repos.packagist composer https://packagist.laravel-china.org
```
