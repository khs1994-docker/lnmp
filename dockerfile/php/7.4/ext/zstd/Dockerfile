# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.7
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-cli-alpine as builder

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG PHP_EXTENSION_EXTRA

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA="zstd-libs"

ARG APK_DEV_EXTRA="zstd-dev "

ENV TZ=Asia/Shanghai

ENV PECL_EXTENSION \
       \
      ${PECL_EXTENSION_EXTRA:-}

ENV EXT_VERSION=0.9.0

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.4.7-alpine,source=/usr/local/bin,target=/opt/bin,rw \
    sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && apk add --no-cache --virtual .ext_build_deps \
                                      $PHPIZE_DEPS \
                                      $APK_DEV_EXTRA \
      && apk add --no-cache --virtual .ext_zstd_run_deps ${APK_EXTRA} \
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
      && php -m \
      \
      && echo $(php-config --extension-dir)/zstd.so > /tmp/ext-zstd-manifest.txt \
      && if [ -d /usr/local/include/php/ext/zstd ];then echo /usr/local/include/php/ext/zstd >> /tmp/ext-zstd-manifest.txt; fi \
      && echo /tmp/ext-zstd-manifest.txt >> /tmp/ext-zstd-manifest.txt \
      && cd / \
      && tar -zcvf ext-zstd.tar.gz --files-from /tmp/ext-zstd-manifest.txt

FROM scratch as bundle

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

COPY --from=builder /ext-zstd.tar.gz /srv/

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test

COPY --from=bundle /srv/ext-zstd.tar.gz /

RUN set -x \
    && tar -zxvf /ext-zstd.tar.gz -C / \
    && apk add --no-cache zstd-libs \
    && echo "extension=zstd" > ${PHP_INI_DIR}/conf.d/docker-php-ext-zstd.ini \
    && php -m

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test-buildkit

RUN --mount=type=bind,from=bundle,source=/srv,target=/srv \
    set -x \
    && tar -zxvf /srv/ext-zstd.tar.gz -C / \
    && apk add --no-cache zstd-libs \
    && echo "extension=zstd" > ${PHP_INI_DIR}/conf.d/docker-php-ext-zstd.ini \
    && php -m
