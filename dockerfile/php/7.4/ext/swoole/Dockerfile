# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.7
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-swoole-alpine as builder

WORKDIR /

RUN set -x \
    && echo $(php-config --extension-dir)/swoole.so > /tmp/ext-swoole-manifest.txt \
    && echo /usr/local/include/php/ext/swoole >> /tmp/ext-swoole-manifest.txt \
    && echo /tmp/ext-swoole-manifest.txt >> /tmp/ext-swoole-manifest.txt \
    && tar -zcvf ext-swoole.tar.gz --files-from /tmp/ext-swoole-manifest.txt

FROM scratch as bundle

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

COPY --from=builder /ext-swoole.tar.gz /srv/

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test

COPY --from=bundle /srv/ext-swoole.tar.gz /

RUN set -x \
    && tar -zxvf /ext-swoole.tar.gz -C / \
    && echo "extension=swoole" > ${PHP_INI_DIR}/conf.d/docker-php-ext-swoole.ini \
    && cat /tmp/ext-swoole-manifest.txt \
    && php -m

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test-buildkit

RUN --mount=type=bind,from=bundle,source=/srv,target=/srv \
    set -x \
    && tar -zxvf /srv/ext-swoole.tar.gz -C / \
    && echo "extension=swoole" > ${PHP_INI_DIR}/conf.d/docker-php-ext-swoole.ini \
    && cat /tmp/ext-swoole-manifest.txt \
    && php -m
