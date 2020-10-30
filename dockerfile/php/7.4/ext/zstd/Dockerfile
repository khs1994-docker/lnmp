# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-cli-alpine as builder

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG EXT_NAME="zstd"

ENV EXT_DEV_DIR="/usr/local/include/php/ext/${EXT_NAME}"

ARG APK_EXTRA="zstd-libs"

ARG APK_DEV_EXTRA="zstd-dev "

ENV TZ=Asia/Shanghai

ENV EXT_VERSION=0.9.0

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN --mount=type=bind,from=php:7.4.12-alpine,source=/usr/local/bin,target=/opt/bin,rw \
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
    && php -m \
      \
    && { \
      echo $(php-config --extension-dir)/${EXT_NAME}.so; \
      echo $( if [ -d ${EXT_DEV_DIR} ];then echo ${EXT_DEV_DIR}; fi ); \
      echo /tmp/ext-${EXT_NAME}-manifest.txt; \
    } | tee /tmp/ext-${EXT_NAME}-manifest.txt \
    && cd / \
    && tar -zcvf ext-${EXT_NAME}.tar.gz --files-from /tmp/ext-${EXT_NAME}-manifest.txt

FROM scratch as bundle

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

ARG EXT_NAME="zstd"

COPY --from=builder /ext-${EXT_NAME}.tar.gz /srv/${EXT_NAME}/

# test

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test

ARG EXT_NAME="zstd"

ARG EXT_RUN_DEPS="zstd-libs"

COPY --from=bundle /srv/${EXT_NAME}/ext-${EXT_NAME}.tar.gz /

RUN set -x \
    && apk add --no-cache ${EXT_RUN_DEPS} \
    && tar -zxvf /ext-${EXT_NAME}.tar.gz -C / \
    && echo "extension=${EXT_NAME}" > ${PHP_INI_DIR}/conf.d/docker-php-ext-${EXT_NAME}.ini \
    && php -m

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine as test-buildkit

ARG EXT_NAME="zstd"

ARG EXT_RUN_DEPS="zstd-libs"

RUN --mount=type=bind,from=bundle,source=/srv,target=/srv \
    set -x \
    && apk add --no-cache ${EXT_RUN_DEPS} \
    && tar -zxvf /srv/${EXT_NAME}/ext-${EXT_NAME}.tar.gz -C / \
    && echo "extension=${EXT_NAME}" > ${PHP_INI_DIR}/conf.d/docker-php-ext-${EXT_NAME}.ini \
    && php -m
