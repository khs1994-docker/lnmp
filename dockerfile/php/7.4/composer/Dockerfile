# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.4.3

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-fpm-alpine

# install composer

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

ENV COMPOSER_DEP_APKS \
      git \
      # 以下两个均为版本控制系统
      # subversion \
      # mercurial \
      openssh-client \
      tini

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=1.9.3 \
    PS1="[\u@\h \w]# " \
    COMPOSER_NO_INTERACTION=1

# https://github.com/composer/docker

RUN --mount=type=bind,from=composer:1.9.3,source=/usr/bin/composer,target=/opt/bin/composer \
    set -x \
    && apk add --no-cache --virtual .php-fpm-apks $COMPOSER_DEP_APKS \
    && echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
    && echo "date.timezone=${PHP_TIMEZONE:-PRC}" > "$PHP_INI_DIR/conf.d/date_timezone.ini" \
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
    && curl -fsSL https://raw.githubusercontent.com/composer/docker/master/1.9/docker-entrypoint.sh \
         -o /docker-entrypoint.composer \
    && chmod +x /docker-entrypoint.composer \
    && cp -a /opt/bin/composer /usr/bin/composer \
    && composer --ansi --version --no-interaction \
    \
# laravel 安装程序
    && composer global require --prefer-dist --ignore-platform-reqs "laravel/installer" \
    \
# && composer global require --prefer-dist --ignore-platform-reqs "ircmaxell/php-compiler" \
# && git clone --depth=1 https://github.com/ircmaxell/php-compiler /tmp/vendor/ircmaxell/php-compiler \
# && cd /tmp/vendor/ircmaxell/php-compiler \
# && composer install --no-dev --prefer-dist --ignore-platform-reqs -n \
# && rm -rf .git ./vendor/**/.git \
# && ln -sf $PWD/bin/* /usr/local/bin \
    \
    && ln -sf /tmp/vendor/bin/* /usr/local/bin \
    && rm -rf /tmp/cache /tmp/installer.php /tmp/*.pub /tmp/composer.lock \
    \
    && ln -sf /tmp/vendor/bin/* /usr/local/bin \
    && rm -rf /tmp/cache /tmp/installer.php /tmp/*.pub /tmp/composer.lock \
# composer 中国镜像
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

ENTRYPOINT ["/docker-entrypoint.composer"]

CMD ["composer"]
