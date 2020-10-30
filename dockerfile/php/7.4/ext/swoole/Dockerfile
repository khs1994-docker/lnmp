# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-swoole-alpine as builder

WORKDIR /

ARG EXT_NAME=swoole

ENV EXT_DEV_DIR=/usr/local/include/php/ext/${EXT_NAME}

RUN set -x \
    && { \
    echo $(php-config --extension-dir)/${EXT_NAME}.so; \
    echo $( if [ -d ${EXT_DEV_DIR} ];then echo ${EXT_DEV_DIR}; fi ); \
    echo /tmp/ext-${EXT_NAME}-manifest.txt; \
     } | tee /tmp/ext-${EXT_NAME}-manifest.txt \
    && tar -zcvf ext-${EXT_NAME}.tar.gz --files-from /tmp/ext-${EXT_NAME}-manifest.txt

FROM scratch as bundle

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

ARG EXT_NAME=swoole

COPY --from=builder /ext-${EXT_NAME}.tar.gz /srv/${EXT_NAME}/

# test

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test

ARG EXT_NAME=swoole

COPY --from=bundle /srv/${EXT_NAME}/ext-${EXT_NAME}.tar.gz /

RUN set -x \
    && tar -zxvf /ext-${EXT_NAME}.tar.gz -C / \
    && echo "extension=${EXT_NAME}" > ${PHP_INI_DIR}/conf.d/docker-php-ext-${EXT_NAME}.ini \
    && cat /tmp/ext-${EXT_NAME}-manifest.txt \
    && php -m

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test-buildkit

ARG EXT_NAME=swoole

RUN --mount=type=bind,from=bundle,source=/srv,target=/srv \
    set -x \
    && tar -zxvf /srv/${EXT_NAME}/ext-${EXT_NAME}.tar.gz -C / \
    && echo "extension=${EXT_NAME}" > ${PHP_INI_DIR}/conf.d/docker-php-ext-${EXT_NAME}.ini \
    && cat /tmp/ext-${EXT_NAME}-manifest.txt \
    && php -m
