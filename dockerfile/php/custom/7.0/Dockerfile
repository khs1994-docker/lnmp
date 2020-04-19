ARG PHP_VERSION=7.0.33

FROM khs1994/php:${PHP_VERSION}-fpm-alpine

# 扩展源码在 PHP 源码
ENV PHP_CORE_EXT \
    wddx \
    xsl

ENV PHP_PECL_EXT \
    imagick \
    msgpack

ENV EXT_BUILD_DEP \
    libxslt-dev

ENV EXT_RUN_DEP \
    libxslt

RUN set -x \
    # 安装构建依赖，构建之后可以删除
    && apk add --no-cache --virtual .pecl_build_deps $EXT_BUILD_DEP $PHPIZE_DEPS \
    # 安装运行依赖，不可以删除
    && apk add --no-cache $EXT_RUN_DEP \
    # ！请自行编辑以下内容
    # 解压 PHP 源码，仅当扩展源码在 PHP 源码中时需要
    && docker-php-source extract \
    #
    # 5.6 | 7.0
    #
    # && docker-php-ext-configure XXX --XXX \
    && docker-php-ext-install $PHP_CORE_EXT \
    && docker-php-ext-enable $PHP_CORE_EXT \
    && for extension in ${PHP_PECL_EXT};do \
         ext_real_name=$(echo ${extension} | cut -d '-' -f 1) \
         && pecl install $extension \
         && docker-php-ext-enable $ext_real_name || echo "pecl ${extension} install error" \
         && rm -rf /usr/local/lib/php/doc/$ext_real_name \
         && rm -rf /usr/local/lib/php/test/$ext_real_name \
         && rm -rf /usr/local/include/php/ext/$ext_real_name \
         && strip --strip-all $(php-config --extension-dir)/$ext_real_name.so ; \
       done \
    #
    # 7.1 + 可以使用 pickle 安装 PHP 扩展
    #
    # && pickle install $PHP_CORE_EXT $PHP_PECL_EXT -n --defaults --strip --cleanup \
    # ！请自行编辑以上内容
    # 清理
    && docker-php-source delete \
    && apk del --no-network .pecl_build_deps \
    && rm -rf /tmp/* \
    && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
    # 验证
    && php -m \
    && ls -la $(php-config --extension-dir)
    # ！请自行编辑以下内容
    # 默认不启用的扩展可以将配置文件改为不以 .ini 结尾的文件名
    # && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    #     /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default
