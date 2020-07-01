# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.7
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-ext-zstd-alpine as zstd

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-ext-swoole-alpine as swoole

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as bundle

ARG EXT_NAME="zstd swoole"

ARG EXT_RUN_DEPS="zstd-libs"

RUN --mount=type=bind,from=zstd,source=/srv,target=/srv/zstd \
    --mount=type=bind,from=swoole,source=/srv,target=/srv/swoole \
    set -x \
    && php -m \
    && apk add --no-cache ${EXT_RUN_DEPS} \
    && tar -zxvf /srv/zstd/ext-zstd.tar.gz -C / \
    && tar -zxvf /srv/swoole/ext-swoole.tar.gz -C / \
    && echo "extension=zstd" > ${PHP_INI_DIR}/conf.d/docker-php-ext-${EXT_NAME}.ini \
    && echo "extension=swoole" > ${PHP_INI_DIR}/conf.d/docker-php-ext-${EXT_NAME}.ini \
    && php -m
