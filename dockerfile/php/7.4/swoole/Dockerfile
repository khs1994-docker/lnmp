# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.3

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-cli-alpine

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

ARG PHP_EXTENSION_EXTRA="ffi"

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA

ARG APK_DEV_EXTRA

ENV TZ=Asia/Shanghai \
    APP_ENV=development

ENV PECL_EXTENSION \
      swoole \
      ${PECL_EXTENSION_EXTRA:-}

ENV SWOOLE_VERSION=4.4.16

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.4.3-alpine,source=/usr/local/bin,target=/opt/bin,rw \
    sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && apk add --no-cache --virtual .pecl_build_deps \
                                      $PHPIZE_DEPS \
                                      openssl-dev \
      && export PATH=$PATH:/opt/bin \
      && echo " \
           --enable-openssl \
           --enable-http2" > /tmp/swoole.configure.options \
      && pickle install https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz \
         -n --defaults --strip --cleanup \
      && apk del --no-network --no-cache .pecl_build_deps \
      && rm -rf /tmp/* \
      && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/*

WORKDIR /app

ENTRYPOINT ["php"]
CMD ["index.php"]
