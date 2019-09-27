# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.3.9

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-cli-alpine

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

ARG PHP_EXTENSION_EXTRA

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA

ARG APK_DEV_EXTRA

ENV PECL_EXTENSION \
      swoole \
      ${PECL_EXTENSION_EXTRA:-}

ENV SWOOLE_VERSION=4.4.7

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.3.9-alpine,source=/usr/local/bin,target=/opt/bin,rw \
    sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && apk add --no-cache --virtual .pecl_build_deps $PHPIZE_DEPS \
      && export PATH=$PATH:/opt/bin \
      && export extension_name=swoole \
      && cd /tmp \
      && curl -fsSL https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz \
           | tar -zxvf - \
      && cd swoole-src-${SWOOLE_VERSION} \
      && phpize \
      && ./configure \
           --enable-sockets \
           --enable-openssl \
           --enable-http2 \
           --enable-mysqlnd \
      && make \
      && make install \
      && docker-php-ext-enable ${extension_name} || echo "pecl ${extension_name} install error" \
      && rm -rf /usr/local/lib/php/doc/${extension_name} \
      && rm -rf /usr/local/lib/php/test/${extension_name} \
      && rm -rf /usr/local/include/php/ext/${extension_name} \
      && strip --strip-all $(php-config --extension-dir)/${extension_name}.so \
      && apk del --no-network --no-cache .pecl_build_deps \
      && rm -rf /tmp/* \
      && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/*

WORKDIR /app

ENTRYPOINT ["php"]

CMD ["index.php"]
