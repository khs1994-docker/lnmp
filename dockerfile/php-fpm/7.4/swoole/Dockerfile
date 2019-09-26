# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.0RC1

FROM --platform=$TARGETPLATFORM php:${PHP_VERSION}-cli-alpine

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

ARG PHP_EXTENSION_EXTRA="ffi"

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA="libgcrypt"

ARG APK_DEV_EXTRA="libgpg-error-dev libgcrypt-dev"

ENV TZ=Asia/Shanghai \
    APP_ENV=development

ENV PECL_EXTENSION \
# 安装测试版的扩展，可以在扩展名后加 -beta
      # xdebug-beta \
      swoole \
      ${PECL_EXTENSION_EXTRA:-}

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
        && apk add --no-cache --virtual .pecl_build_deps $PHPIZE_DEPS \
        && for extension in $PECL_EXTENSION;do \
             pecl install $extension \
             && docker-php-ext-enable $(echo ${extension} | cut -d '-' -f 1) || echo "pecl ${extension} install error" \
             && rm -rf /usr/local/lib/php/doc/$(echo ${extension} | cut -d '-' -f 1) \
             && rm -rf /usr/local/lib/php/test/$(echo ${extension} | cut -d '-' -f 1) \
             && rm -rf /usr/local/include/php/ext/$(echo ${extension} | cut -d '-' -f 1) \
             && strip --strip-all $(php-config --extension-dir)/$(echo ${extension} | cut -d '-' -f 1).so ; \
           done \
# https://github.com/tideways/php-xhprof-extension.git
        && test `uname -m` = 'x86_64' \
        && (cd /tmp \
        && curl -fsSL https://github.com/tideways/php-xhprof-extension/archive/master.tar.gz \
           | tar -zxvf - \
        && cd php-xhprof-extension-master \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && docker-php-ext-enable tideways_xhprof \
        && mv /usr/local/etc/php/conf.d/docker-php-ext-tideways_xhprof.ini \
          /usr/local/etc/php/conf.d/docker-php-ext-tideways_xhprof.ini.default) \
        || true \
        && apk del --no-network --no-cache .pecl_build_deps \
        && rm -rf /tmp/* \
        && rm -rf /usr/local/lib/php/.registry/.channel.pecl.php.net/*

WORKDIR /app

ENTRYPOINT ["php"]
CMD ["index.php"]
