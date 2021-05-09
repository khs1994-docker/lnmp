# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.19
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-cli-alpine as builder

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG EXT_NAME="zstd"

ARG APK_EXTRA="zstd-libs"

ARG APK_DEV_EXTRA="zstd-dev "

ENV EXT_VERSION=0.9.0

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.4.19-alpine,source=/usr/local/bin,target=/opt/bin,rw \
    set -x \
    && sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    && apk add --no-cache --virtual .ext_build_deps \
                                      $PHPIZE_DEPS \
                                      $APK_DEV_EXTRA \
    && apk add --no-cache --virtual .ext_${EXT_NAME}_run_deps ${APK_EXTRA} \
    && export PATH=$PATH:/opt/bin \
    && echo " \
           --with-libzstd \
           " > /tmp/zstd.configure.options \
    && pickle install https://github.com/kjdev/php-ext-zstd/archive/${EXT_VERSION}.tar.gz \
         -n --defaults --strip --cleanup \
    && apk del --no-network .ext_build_deps \
    && rm -rf /tmp/* \
    && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
# test
    && php -m
