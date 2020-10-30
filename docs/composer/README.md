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

* https://github.com/Webysther/packagist-mirror

```bash
# 每 5min 更新
$ composer config -g repos.packagist composer https://mirrors.aliyun.com/composer/

# 每日更新
$ composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/

# 不推荐
$ composer config -g repos.packagist composer https://packagist.mirrors.sjtug.sjtu.edu.cn
```

**过时**

* https://packagist.phpcomposer.com
* https://mirrors.huaweicloud.com/repository/php/

**取消配置**

```bash
$ composer config -g --unset repos.packagist
```

* https://developer.aliyun.com/composer
* https://mirrors.sjtug.sjtu.edu.cn/packagist/
* https://mirrors.cloud.tencent.com/composer/
