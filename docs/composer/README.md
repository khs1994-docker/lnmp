# Composer

**忽略相关的参数**

```bash
$ composer install \
    --no-plugins \
    --no-interaction \
    --ignore-platform-reqs \
    --no-scripts
```

**国内镜像**

```bash
# https://developer.aliyun.com/composer
$ composer config -g repos.packagist composer https://mirrors.aliyun.com/composer/

# https://mirrors.cloud.tencent.com/help/composer.html
$ composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/
```

**全球镜像**

```bash
$ composer config -g repos.packagist composer https://packagist.pages.dev
```

**过时的镜像（无法使用）**

* ~~Asia, China mirrors.huaweicloud.com/repository/php~~
* Asia, China developer.aliyun.com/composer
* ~~Asia, China php.cnpkg.org~~
* ~~Asia, China packagist.phpcomposer.com~~
* ~~Asia, China packagist.mirrors.sjtug.sjtu.edu.cn~~
* Asia, China mirrors.cloud.tencent.com/help/composer.html

**取消配置**

```bash
$ composer config -g --unset repos.packagist
```
