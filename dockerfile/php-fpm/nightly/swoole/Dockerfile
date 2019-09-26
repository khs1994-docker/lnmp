# syntax=docker/dockerfile:experimental
FROM --platform=$TARGETPLATFORM khs1994/php:nightly-cli-alpine

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

ARG ALPINE_URL=dl-cdn.alpinelinux.org

ARG PHP_EXTENSION_EXTRA

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA

ARG APK_DEV_EXTRA

ENV PECL_EXTENSION \
      swoole-beta \
      ${PECL_EXTENSION_EXTRA:-}

RUN --mount=type=bind,from=php:alpine,source=/usr/local/bin,target=/opt/bin,rw \
    --mount=type=cache,target=/usr/local/lib/php/test \
    --mount=type=cache,target=/usr/local/lib/php/doc \
      set -x \
      && export PATH=$PATH:/opt/bin \
      && apk add --no-cache --virtual .pecl_build_deps $PHPIZE_DEPS \
      && curl -sfL -o /usr/local/bin/pickle \
        https://github.com/khs1994-php/pickle/releases/download/v0.4.0-2019-02-14/pickle.phar \
      && chmod +x /usr/local/bin/pickle \
      && for extension in $PECL_EXTENSION;do \
           EXT_REAL_NAME=$(echo ${extension} | cut -d '-' -f 1) \
           && pickle install $extension -n --defaults \
           || (cd /tmp/${EXT_REAL_NAME}/${EXT_REAL_NAME}* \
           && phpize \
           && ./configure \
           && make \
           && make install \
           && rm -rf /tmp/${EXT_REAL_NAME}) \
           && docker-php-ext-enable ${EXT_REAL_NAME} || echo "pecl ${extension} install error" \
           && rm -rf /usr/local/include/php/ext/${EXT_REAL_NAME} \
           && strip --strip-all $(php-config --extension-dir)/${EXT_REAL_NAME}.so || true ; \
         done \
         \
      ; apk del --no-network --no-cache .pecl_build_deps \
      && rm -rf /tmp/* \
      && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/*

WORKDIR /app

ENTRYPOINT ["php"]

CMD ["index.php"]
