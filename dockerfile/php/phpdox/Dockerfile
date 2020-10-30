ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994
ARG BASE=composer

FROM alpine as downloader

ARG PHPDOX_VERSION=0.12.0

RUN set -x ; apk add --no-cache curl \
    && curl -fsSL https://github.com/theseer/phpdox/releases/download/${PHPDOX_VERSION}/phpdox-${PHPDOX_VERSION}.phar \
         -o /usr/local/bin/phpdox \
    && chmod +x /usr/local/bin/phpdox

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

# 扩展源码在 PHP 源码
ENV PHP_CORE_EXT \
    xsl

ENV EXT_BUILD_DEP \
    libxslt-dev

ENV EXT_RUN_DEP \
    libxslt

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN set -x \
    && sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    # 安装构建依赖，构建之后可以删除
    && apk add --no-cache --virtual .pecl_build_deps $EXT_BUILD_DEP $PHPIZE_DEPS \
    # 安装运行依赖，不可以删除
    && apk add --no-cache $EXT_RUN_DEP \
    # ！请自行编辑以下内容
    # 解压 PHP 源码，仅当扩展源码在 PHP 源码中时需要
    && docker-php-source extract \
    && pickle install $PHP_CORE_EXT $PHP_PECL_EXT -n --defaults --strip --cleanup \
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

COPY --from=downloader /usr/local/bin/phpdox /usr/local/bin/phpdox

ENTRYPOINT [ "phpdox" ]
