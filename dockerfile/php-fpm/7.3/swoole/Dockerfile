# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.3.6

FROM --platform=$TARGETPLATFORM php:${PHP_VERSION}-cli-alpine as php

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
      yaml \
      swoole \
      ${PECL_EXTENSION_EXTRA:-}

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && set -xe \
      # 不要删除
      && PHP_SWOOLE_RUN_DEPS=" \
                         bash \
                         tzdata \
                         libmemcached-libs \
                         libpq \
                         libzip \
                         zlib \
                         libpng \
                         freetype \
                         libjpeg-turbo \
                         libxpm \
                         libwebp \
                         yaml \
                         libbz2 \
                         libexif \
                         libxslt \
                         gmp \
                         xmlrpc-c \
                         enchant \
                         c-client \
                         icu-libs \
                         ${APK_EXTRA:-} \
                         " \
                         # tidyhtml-libs \
      # *-dev 编译之后删除
      && PHP_SWOOLE_BUILD_DEPS=" \
                         openssl-dev \
                         libmemcached-dev \
                         cyrus-sasl-dev \
                         postgresql-dev \
                         libzip-dev \
                         zlib-dev \
                         libpng-dev \
                         freetype-dev \
                         libjpeg-turbo-dev \
                         libxpm-dev \
                         libwebp-dev \
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
                         nghttp2-dev \
                         ${APK_DEV_EXTRA:-} \
                         " \
                         # tidyhtml-dev \
        && apk add --no-cache --virtual .php-swoole-run-deps $PHP_SWOOLE_RUN_DEPS \
        && apk add --no-cache --virtual .php-swoole-build-deps $PHP_SWOOLE_BUILD_DEPS \
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
        && apk add --no-cache --virtual .build-deps \
                                # linux-headers \
                                $PHPIZE_DEPS \
        && for extension in ${PHP_EXTENSION};do \
             strip --strip-all $(php-config --extension-dir)/$(echo ${extension} | cut -d '-' -f 1).so ; \
           done \
        && for extension in $PECL_EXTENSION;do \
             pecl install $extension \
             && docker-php-ext-enable $(echo ${extension} | cut -d '-' -f 1) || echo "pecl ${extension} install error" \
             && rm -rf /usr/local/lib/php/doc/$(echo ${extension} | cut -d '-' -f 1) \
             && rm -rf /usr/local/lib/php/test/$(echo ${extension} | cut -d '-' -f 1) \
             && rm -rf /usr/local/include/php/ext/$(echo ${extension} | cut -d '-' -f 1) \
             && strip --strip-all $(php-config --extension-dir)/$(echo ${extension} | cut -d '-' -f 1).so ; \
           done \
        && apk del --no-network --no-cache .build-deps .php-swoole-build-deps \
        && rm -rf /tmp/* \
        && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
        && rm -rf /usr/local/sbin

WORKDIR /app

ENTRYPOINT ["php"]

CMD ["index.php"]
