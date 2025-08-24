# syntax=ghcr.io/dpsigs/docker-dockerfile-upstream:master-labs
ARG PHP_VERSION=8.4.11

FROM --platform=$TARGETPLATFORM ghcr.io/khs1994-docker/library/php:${PHP_VERSION}-fpm-alpine3.22 as php

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
      redis \
      # https://github.com/phpredis/phpredis/archive/develop.tar.gz \
      memcached \
# 安装测试版的扩展，可以在扩展名后加 -beta
      # xdebug-beta \
      # yaml \
      # https://github.com/php/pecl-file_formats-yaml/archive/php7.tar.gz \
      https://github.com/kjdev/php-ext-zstd/archive/0.11.0.tar.gz \
      ${PECL_EXTENSION_EXTRA:-}

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=ghcr.io/php/pie:bin,source=/,target=/opt/bin2,rw \
    sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
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
# 安装内置扩展
        && docker-php-source extract \
        && curl -fsSL -o /tmp/igbinary.tar.gz https://github.com/igbinary/igbinary/archive/master.tar.gz \
        && tar -zxvf /tmp/igbinary.tar.gz -C /usr/src/php/ext/ \
        && mv /usr/src/php/ext/igbinary-master /usr/src/php/ext/igbinary \
        && docker-php-ext-configure zip \
                                    --with-zip \
        && docker-php-ext-configure gd \
                                        --disable-gd-jis-conv \
                                        --with-freetype \
                                        --with-jpeg \
                                        --with-webp \
                                        --with-xpm \
                                        --with-avif \
        && docker-php-ext-configure igbinary \
        && docker-php-ext-install $PHP_EXTENSION gd zip igbinary \
        && docker-php-source delete \
        && docker-php-ext-enable opcache \
        && export PATH=$PATH:/opt/bin:/opt/bin2 \
        && export PIE_CONFIG="--with-php-config=/usr/local/bin/php-config \
                            --with-php-path=/usr/local/bin/php \
                            --with-phpize-path=/usr/local/bin/phpize \
                            --skip-enable-extension \
                            --force" \
        && pie -n install ${PIE_CONFIG} \
                      kjdev/zstd \
        # && pie -n install ${PIE_CONFIG} \
        #                igbinary/igbinary:dev-main \
        && pie -n install ${PIE_CONFIG} \
                      phpredis/phpredis \
                      --enable-redis-igbinary --enable-redis-zstd \
        && pie -n install ${PIE_CONFIG} \
                      php-memcached/php-memcached \
                      --enable-memcached-igbinary \
        && pie -n install ${PIE_CONFIG} \
                      xdebug/xdebug \
        && docker-php-ext-enable zstd \
                                redis \
                                memcached \
        && strip --strip-all $(php-config --extension-dir)/redis.so \
        && strip --strip-all $(php-config --extension-dir)/memcached.so \
        && strip --strip-all $(php-config --extension-dir)/zstd.so \
        && strip --strip-all $(php-config --extension-dir)/xdebug.so \
        && rm -rf /tmp/* \
        && rm -rf /root/.pie \
        && rm -rf /root/.composer \
        && rm -rf /usr/src/php \
        && apk del --no-network .phpize-deps .php-fpm-build-deps \
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
