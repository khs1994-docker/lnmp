# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994
ARG BASE=fpm

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

# install composer

ENV COMPOSER_DEP_APKS \
      git \
      openssh-client \
      tini

# https://getcomposer.org/doc/03-cli.md#environment-variables

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp/composer \
    COMPOSER_NO_INTERACTION=1 \
    # COMPOSER_ALLOW_XDEBUG= \
    # COMPOSER_AUTH= \
    # COMPOSER_CAFILE= \
    # COMPOSER_CACHE_DIR=/tmp/composer/cache \
    # COMPOSER_DISABLE_XDEBUG_WARN= \
    # COMPOSER_DISCARD_CHANGES= \
    # COMPOSER_HTACCESS_PROTECT= \
    # COMPOSER_MEMORY_LIMIT= \
    COMPOSER_PROCESS_TIMEOUT=300 \
    # COMPOSER_SELF_UPDATE_TARGET= \
    COMPOSER_VERSION=2.0.3 \
    PS1="[\u@\h \w]# "

# https://github.com/composer/docker

RUN --mount=type=bind,from=composer:2.0.3,source=/usr/bin/composer,target=/opt/bin/composer \
    set -x \
    && apk add --no-cache --virtual .composer_deps $COMPOSER_DEP_APKS \
    && { echo "memory_limit=-1"; \
         echo "date.timezone=${PHP_TIMEZONE:-PRC}"; \
       } | tee ${PHP_INI_DIR}/conf.d/php-cli.ini \
 #    && curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
 #    && php -r " \
 #    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
 #    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
 #    if (!hash_equals(\$signature, \$hash)) { \
 #        unlink('/tmp/installer.php'); \
 #        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
 #        exit(1); \
 #    }" \
 # && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && curl -fsSL https://raw.githubusercontent.com/composer/docker/master/2.0/docker-entrypoint.sh \
         -o /docker-entrypoint.composer \
    && chmod +x /docker-entrypoint.composer \
    && cp -a /opt/bin/composer /usr/bin/composer \
    && composer --ansi --version --no-interaction \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache gosu \
    \
# laravel 安装程序
#    && composer global require --prefer-dist --ignore-platform-reqs "laravel/installer" \
    \
#    && ln -sf /tmp/composer/vendor/bin/* /usr/local/bin \
    && rm -rf /tmp/composer/cache \
              /tmp/composer/composer.lock \
              /tmp/installer.php \
              /tmp/*.pub \
# composer 中国镜像
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

ENTRYPOINT ["/docker-entrypoint.composer"]

CMD ["composer"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
