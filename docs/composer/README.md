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

$ composer config -g repos.packagist composer https://repo.huaweicloud.com/repository/php/

# https://mirrors.cloud.tencent.com/help/composer.html
$ composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/
```

**过时的镜像（无法使用）**

* https://packagist.mirrors.sjtug.sjtu.edu.cn
* https://packagist.phpcomposer.com
* https://php.cnpkg.org

**取消配置**

```bash
$ composer config -g --unset repos.packagist
```

**测试命令**

```powershell
$MIRROR="mirrors.aliyun.com/composer/"
docker run -it --rm khs1994/php:8.1.1-composer-alpine sh -cx "composer config -g repos.packagist composer https://$MIRROR ; composer require laravel/laravel"
```
