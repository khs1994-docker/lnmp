# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.3.24
ARG USERNAME=khs1994
ARG BASE=cli

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG PHP_EXTENSION_EXTRA

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA

ARG APK_DEV_EXTRA

ENV PECL_EXTENSION \
      swoole \
      ${PECL_EXTENSION_EXTRA:-}

ENV SWOOLE_VERSION=4.5.6

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.3.24-alpine,source=/usr/local/bin,target=/opt/bin,rw \
    set -x \
    && sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    && apk add --no-cache --virtual .pecl_build_deps \
                                    $PHPIZE_DEPS \
                                    openssl-dev \
                                    pcre2-dev \
    && export PATH=$PATH:/opt/bin \
    && echo " \
           --enable-openssl \
           --enable-http2" > /tmp/swoole.configure.options \
    && pickle install https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz \
         -n --defaults --strip --cleanup \
    && apk del --no-network .pecl_build_deps \
    && rm -rf /tmp/* \
    && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/*

WORKDIR /app

ENTRYPOINT ["php"]

CMD ["index.php"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
