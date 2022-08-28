# syntax=docker/dockerfile:labs
ARG PHP_VERSION=8.2.0beta3

FROM --platform=$TARGETPLATFORM php:${PHP_VERSION}-fpm-alpine3.16 as php

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
      # xsl \
      zip \
      shmop \
      ffi \
      ${PHP_EXTENSION_EXTRA:-}

ENV PECL_EXTENSION \
      # mongodb \
      # https://github.com/mongodb/mongo-php-driver/archive/master.tar.gz \
      # igbinary \
      https://github.com/igbinary/igbinary/archive/master.tar.gz \
      # redis \
      https://github.com/phpredis/phpredis/archive/develop.tar.gz \
      memcached \
# 安装测试版的扩展，可以在扩展名后加 -beta
      # xdebug-beta \
      # yaml \
      # https://github.com/php/pecl-file_formats-yaml/archive/php7.tar.gz \
      https://github.com/kjdev/php-ext-zstd/archive/0.11.0.tar.gz \
      ${PECL_EXTENSION_EXTRA:-}

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && set -xe \
      \
      # && apk add --no-cache patch \
      # && cd / \
      # && { \
      #   echo "--- a/usr/local/lib/php/build/php.m4"; \
      #    } | tee 1.diff \
      # && patch -p1 < 1.diff \
      # && apk del --no-network patch \
      # && rm -rf 1.diff \
      \
# 不要删除
      && PHP_FPM_RUN_DEPS=" \
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
                         libbz2 \
                         libexif \
                         gmp \
                         enchant2 \
                         c-client \
                         icu-libs \
                         zstd-libs \
# https://github.com/xdebug/xdebug/pull/835
                         linux-headers \
                         libavif \
                         ${APK_EXTRA:-} \
                         " \
                         # tidyhtml-libs \
                         # libxslt \
                         # yaml \
# *-dev 编译之后删除
      && PHP_FPM_BUILD_DEPS=" \
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
                         libexif-dev \
                         gmp-dev \
                         bzip2-dev \
                         enchant2-dev \
                         imap-dev \
                         gettext-dev \
                         libwebp-dev \
                         icu-dev \
                         zstd-dev \
                         libavif-dev \
                         ${APK_DEV_EXTRA:-} \
                         " \
                         # tidyhtml-dev \
                         # libxslt-dev \
                         # yaml-dev \
        && apk add --no-cache --virtual .php-fpm-run-deps $PHP_FPM_RUN_DEPS \
        && apk add --no-cache --virtual .php-fpm-build-deps $PHP_FPM_BUILD_DEPS \
        && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
        && curl -fsSL -o /usr/local/bin/pickle \
           https://github.com/khs1994-php/pickle/releases/download/nightly/pickle-debug.phar \
        && chmod +x /usr/local/bin/pickle \
# 安装内置扩展
        && docker-php-source extract \
        && docker-php-ext-configure zip \
                                    --with-zip \
        && docker-php-ext-install zip \
        && strip --strip-all $(php-config --extension-dir)/zip.so \
        # && docker-php-ext-configure gd \
        && echo " \
                                        --disable-gd-jis-conv \
                                        --with-freetype \
                                        --with-jpeg \
                                        --with-webp \
                                        --with-xpm \
                                        --with-avif" > /tmp/gd.configure.options \
        # && docker-php-ext-install $PHP_EXTENSION \
        && pickle install $PHP_EXTENSION -n --defaults --strip \
        && docker-php-source delete \
# 安装 PECL 扩展
        && echo "--enable-redis-igbinary --enable-redis-zstd" > /tmp/redis.configure.options \
        && echo "--enable-memcached-igbinary" > /tmp/memcached.configure.options \
        && echo "--with-libzstd" > /tmp/zstd.configure.options \
        && pickle install $PECL_EXTENSION -n --defaults \
           --strip --cleanup \
# 默认不启用的扩展
        && pickle install \
             # xdebug \
             https://github.com/xdebug/xdebug/archive/master.tar.gz \
# https://github.com/tideways/php-xhprof-extension.git
             https://github.com/tideways/php-xhprof-extension/archive/master.tar.gz \
             -n --defaults --strip --cleanup --no-write \
        && pickle install opcache \
        # && docker-php-ext-enable opcache \
        && apk del --no-network .phpize-deps .php-fpm-build-deps \
        && rm -rf /tmp/* \
# 创建日志文件夹
        && mkdir -p /var/log/php-fpm \
        && ln -sf /dev/stdout /var/log/php-fpm/access.log \
        && ln -sf /dev/stderr /var/log/php-fpm/error.log \
        && ln -sf /dev/stderr /var/log/php-fpm/xdebug-remote.log \
        && chmod -R 777 /var/log/php-fpm \
        && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
        && php -m \
        && ls -la $(php-config --extension-dir) \
        && php -d error_reporting=22527 -d display_errors=1 -r 'var_dump(iconv("UTF-8", "UTF-8//IGNORE", "This is the Euro symbol '\''€'\''."));' \
# smoke test
        && php --version

WORKDIR /app

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
