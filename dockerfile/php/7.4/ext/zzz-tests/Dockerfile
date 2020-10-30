# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-ext-zstd-alpine as zstd

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-ext-swoole-alpine as swoole

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-ext-yaml-alpine as yaml

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-ext-mongodb-alpine as mongodb

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as bundle

ARG EXT_NAME="zstd swoole yaml mongodb"

ARG EXT_RUN_DEPS="zstd-libs yaml"

RUN --mount=type=bind,from=zstd,source=/srv/zstd,target=/srv/zstd \
    --mount=type=bind,from=swoole,source=/srv/swoole,target=/srv/swoole \
    --mount=type=bind,from=yaml,source=/srv/yaml,target=/srv/yaml \
    --mount=type=bind,from=mongodb,source=/srv/mongodb,target=/srv/mongodb \
    \
    set -x \
    && php -m \
    && apk add --no-cache ${EXT_RUN_DEPS} \
    \
    && tar -zxvf /srv/zstd/ext-zstd.tar.gz -C / \
    && tar -zxvf /srv/swoole/ext-swoole.tar.gz -C / \
    && tar -zxvf /srv/yaml/ext-yaml.tar.gz -C / \
    && tar -zxvf /srv/mongodb/ext-mongodb.tar.gz -C / \
    \
    && echo "extension=zstd" > ${PHP_INI_DIR}/conf.d/docker-php-ext-zstd.ini \
    && echo "extension=swoole" > ${PHP_INI_DIR}/conf.d/docker-php-ext-swoole.ini \
    && echo "extension=yaml" > ${PHP_INI_DIR}/conf.d/docker-php-ext-yaml.ini \
    && echo "extension=mongodb" > ${PHP_INI_DIR}/conf.d/docker-php-ext-mongodb.ini \
    \
    && php -m
