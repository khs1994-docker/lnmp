ARG PHP_VERSION=5.6.40

FROM --platform=$TARGETPLATFORM php:${PHP_VERSION}-fpm-alpine as php

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

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
      # xmlrpc \
      # xsl \
      zip \
      ${PHP_EXTENSION_EXTRA:-}

ENV PECL_EXTENSION \
      # mongodb-1.7.4 \
      igbinary-2.0.8 \
      redis-4.3.0 \
      memcached-2.2.0 \
# 安装测试版的扩展，可以在扩展名后加 -beta
      xdebug-2.5.5 \
      yaml-1.3.2 \
      ${PECL_EXTENSION_EXTRA:-}

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && set -xe \
# 不要删除
      && PHP_FPM_RUN_DEPS=" \
                         bash \
                         tzdata \
                         libmemcached-libs \
                         libpq \
                         zlib \
                         libpng \
                         freetype \
                         libjpeg-turbo \
                         libxpm \
                         yaml \
                         libbz2 \
                         libexif \
                         gmp \
                         # xmlrpc-c \
                         enchant \
                         c-client \
                         icu-libs \
                         ${APK_EXTRA:-} \
                         " \
                         # tidyhtml-libs \
                         # libxslt \
# *-dev 编译之后删除
      && PHP_FPM_BUILD_DEPS=" \
                         libressl-dev \
                         libmemcached-dev \
                         cyrus-sasl-dev \
                         postgresql-dev \
                         zlib-dev \
                         libpng-dev \
                         freetype-dev \
                         libjpeg-turbo-dev \
                         libxpm-dev \
                         yaml-dev \
                         libexif-dev \
                         gmp-dev \
                         # xmlrpc-c-dev \
                         bzip2-dev \
                         enchant-dev \
                         imap-dev \
                         gettext-dev \
                         libwebp-dev \
                         icu-dev \
                         ${APK_DEV_EXTRA:-} \
                         " \
                         # tidyhtml-dev \
                         # libxslt-dev \
        && apk add --no-cache --virtual .php-fpm-run-deps $PHP_FPM_RUN_DEPS \
        && apk add --no-cache --virtual .php-fpm-build-deps $PHP_FPM_BUILD_DEPS \
        && docker-php-ext-configure gd \
                                    --with-freetype-dir=/usr \
                                    --with-jpeg-dir=/usr \
                                    --with-png-dir=/usr \
                                    --with-xpm-dir=/usr \
        && docker-php-ext-install $PHP_EXTENSION \
        && apk add --no-cache --virtual .build-deps \
                                          # linux-headers \
                                          $PHPIZE_DEPS \
        && for extension in ${PHP_EXTENSION};do \
             ext_real_name=$(echo ${extension} | cut -d '-' -f 1) \
             && strip --strip-all $(php-config --extension-dir)/$ext_real_name.so ; \
           done \
        && for extension in ${PECL_EXTENSION};do \
             ext_real_name=$(echo ${extension} | cut -d '-' -f 1) \
             && pecl install $extension \
             && docker-php-ext-enable $ext_real_name || echo "pecl ${extension} install error" \
             && rm -rf /usr/local/lib/php/doc/$ext_real_name \
             && rm -rf /usr/local/lib/php/test/$ext_real_name \
             && rm -rf /usr/local/include/php/ext/$ext_real_name \
             && strip --strip-all $(php-config --extension-dir)/$ext_real_name.so ; \
           done \
        && docker-php-ext-enable opcache \
        && apk del --no-network .build-deps .php-fpm-build-deps \
# 默认不启用 xdebug
        && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
          /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default \
        && rm -rf /tmp/* \
        && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
# 创建日志文件夹
        && mkdir -p /var/log/php-fpm \
        && ln -sf /dev/stdout /var/log/php-fpm/access.log \
        && ln -sf /dev/stderr /var/log/php-fpm/error.log \
        && ln -sf /dev/stderr /var/log/php-fpm/xdebug-remote.log \
        && chmod -R 777 /var/log/php-fpm

STOPSIGNAL SIGQUIT

WORKDIR /app
