# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.12

FROM --platform=$TARGETPLATFORM php:${PHP_VERSION}-fpm-alpine3.11 as php

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG PHP_EXTENSION_EXTRA="ffi"

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
      shmop \
      ${PHP_EXTENSION_EXTRA:-}

ENV PECL_EXTENSION \
      igbinary \
      redis \
      memcached \
# 安装测试版的扩展，可以在扩展名后加 -beta
      # xdebug-beta \
      https://github.com/kjdev/php-ext-zstd/archive/0.9.0.tar.gz \
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
                         # xmlrpc-c \
                         enchant \
                         c-client \
                         icu-libs \
                         gnu-libiconv \
                         zstd-libs \
                         ${APK_EXTRA:-} \
                         " \
                         # tidyhtml-libs \
                         # libxslt \
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
                         # xmlrpc-c-dev \
                         bzip2-dev \
                         enchant-dev \
                         imap-dev \
                         gettext-dev \
                         libwebp-dev \
                         icu-dev \
                         zstd-dev \
                         ${APK_DEV_EXTRA:-} \
                         " \
                         # tidyhtml-dev \
                         # libxslt-dev \
        && apk add --no-cache --virtual .php-fpm-run-deps $PHP_FPM_RUN_DEPS \
        && apk add --no-cache --virtual .php-fpm-build-deps $PHP_FPM_BUILD_DEPS patch \
        && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
        && curl -fsSL -o /usr/local/bin/pickle \
           https://github.com/khs1994-php/pickle/releases/download/nightly/pickle-debug.phar \
        && chmod +x /usr/local/bin/pickle \
# 安装内置扩展
        && docker-php-source extract \
# enchant-2.patch
        && cd /usr/src/php \
        && curl -fsSL -o enchant-2.patch https://raw.githubusercontent.com/alpinelinux/aports/b315e28b96f16c2a8973a55a736e1e35482203dd/community/php7/enchant-2.patch \
#        && patch -p1 < enchant-2.patch \
        && rm -rf enchant-2.patch \
#        && ./buildconf --force \
        && cd - \
        \
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
                                        --with-xpm" > /tmp/gd.configure.options \
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
             xdebug \
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
        && LD_PRELOAD="/usr/lib/preloadable_libiconv.so php" php -d error_reporting=22527 -d display_errors=1 -r 'var_dump(iconv("UTF-8", "UTF-8//IGNORE", "This is the Euro symbol '\''€'\''."));'

ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php"

WORKDIR /app

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
