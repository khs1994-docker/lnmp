# syntax=docker/dockerfile:labs
ARG PHP_VERSION=7.4.25
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-cli-alpine as builder

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG EXT_NAME="mongodb"

ARG APK_EXTRA

ARG APK_DEV_EXTRA="pcre2-dev"

ENV EXT_VERSION=x.y.z

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.4.25-alpine,source=/usr/local/bin,target=/opt/bin,rw \
    set -x \
    && sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    && apk add --no-cache --virtual .ext_build_deps \
                                      $PHPIZE_DEPS \
                                      $APK_DEV_EXTRA \
    && export PATH=$PATH:/opt/bin \
    && pickle install mongodb \
         -n --defaults --strip --cleanup \
    && apk del --no-network .ext_build_deps \
    && rm -rf /tmp/* \
    && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/* \
# test
    && php -m
