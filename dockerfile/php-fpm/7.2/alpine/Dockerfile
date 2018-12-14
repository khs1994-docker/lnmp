ARG PHP_VERSION=7.2.13

FROM php:${PHP_VERSION}-fpm-alpine as php

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG PHP_EXTENSION_EXTRA

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA

ARG APK_DEV_EXTRA

ENV TZ=Asia/Shanghai \
    APP_ENV=development

ENV PHP_EXTENSION \
      bcmath \
      bz2 \
      calendar \
      enchant \
      exif \
      gd \
      gettext \
      gmp \
      imap \
      intl \
      mysqli \
      pcntl \
      pdo_pgsql \
      pdo_mysql \
      pgsql \
      sockets \
      sysvmsg \
      sysvsem \
      sysvshm \
# tidy \
      xmlrpc \
      xsl \
      zip \
      ${PHP_EXTENSION_EXTRA:-}

ENV PECL_EXTENSION \
      mongodb \
      igbinary \
      redis \
      memcached \
# 安装测试版的扩展，可以在扩展名后加 -beta
      xdebug \
      yaml \
      swoole \
      ${PECL_EXTENSION_EXTRA:-}

# 构建变量默认值为原始值，笔记本构建统一使用 docker-compose 构建
# 国内镜像地址在 docker-compose.yml 中定义

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && set -xe \
      # 不要删除
      && PHP_FPM_RUN_DEPS=" \
                         bash \
                         tzdata \
                         libmemcached \
                         libpq \
                         libzip \
                         libpng \
                         freetype \
                         libjpeg-turbo \
                         yaml \
                         libbz2 \
                         libexif \
                         libxslt \
                         gmp \
                         xmlrpc-c \
                         enchant \
                         c-client \
                         libwebp \
                         icu-libs \
                         libxpm \
                         libwebp \
                         ${APK_EXTRA:-} \
                         " \
                         # tidyhtml-libs \
      # *-dev 编译之后删除
      && PHP_FPM_BUILD_DEPS=" \
                         libressl-dev \
                         libmemcached-dev \
                         cyrus-sasl-dev \
                         postgresql-dev \
                         libzip-dev \
                         libpng-dev \
                         freetype-dev \
                         libjpeg-turbo-dev \
                         yaml-dev \
                         libexif-dev \
                         libxslt-dev \
                         gmp-dev \
                         xmlrpc-c-dev \
                         bzip2-dev \
                         enchant-dev \
                         imap-dev \
                         gettext-dev \
                         libwebp-dev \
                         icu-dev \
                         libxpm-dev \
                         libwebp-dev \
                         ${APK_DEV_EXTRA:-} \
                         " \
                         # tidyhtml-dev \
        && apk add --no-cache --virtual .php-fpm-run-deps $PHP_FPM_RUN_DEPS \
        && apk add --no-cache --virtual .php-fpm-build-deps $PHP_FPM_BUILD_DEPS \
        && docker-php-ext-configure zip \
                                    --with-libzip \
        && docker-php-ext-configure gd \
                                        --disable-gd-jis-conv \
                                        --with-freetype-dir=/usr \
                                        --with-jpeg-dir=/usr \
                                        --with-png-dir=/usr \
                                        --with-webp-dir=/usr \
                                        --with-xpm-dir=/usr \
        && docker-php-ext-install $PHP_EXTENSION \
        && apk add --no-cache --virtual .build-deps linux-headers $PHPIZE_DEPS \
        && for extension in $PECL_EXTENSION;do \
             pecl install $extension \
               && docker-php-ext-enable $(echo ${extension} | cut -d '-' -f 1) || echo "pecl ${extension} install error"; \
           done \
        # https://github.com/tideways/php-xhprof-extension.git
        && cd /tmp \
        && wget https://github.com/tideways/php-xhprof-extension/archive/master.zip \
        && unzip master.zip \
        && cd php-xhprof-extension-master \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && docker-php-ext-enable opcache tideways_xhprof \
        && apk del --no-cache .build-deps .php-fpm-build-deps \
        && rm -rf /tmp/* \
        # 默认不启用 xdebug
        && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
          /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default \
        && mv /usr/local/etc/php/conf.d/docker-php-ext-tideways_xhprof.ini \
          /usr/local/etc/php/conf.d/docker-php-ext-tideways_xhprof.ini.default \
        # config opcache
        # && echo 'opcache.enable_cli=1' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini \
        # && echo 'opcache.file_cache=/tmp' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini \
        # 创建日志文件夹
        && mkdir -p /var/log/php-fpm \
        && ln -sf /dev/stdout /var/log/php-fpm/access.log \
        && ln -sf /dev/stderr /var/log/php-fpm/error.log \
        && ln -sf /dev/stderr /var/log/php-fpm/xdebug-remote.log \
        && chmod -R 777 /var/log/php-fpm

WORKDIR /app
