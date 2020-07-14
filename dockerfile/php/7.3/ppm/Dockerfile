# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.3.18
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-composer-alpine as composer

RUN mkdir /ppm \
      && cd /ppm \
      && composer config -g --unset repos.packagist \
      && composer require php-pm/php-pm --no-cache \
      && composer require php-pm/httpkernel-adapter --no-cache \
      && rm -rf /tmp/composer/cache /ppm/composer*

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-cli-alpine

RUN --mount=type=cache,from=composer,source=/ppm,target=/tmp/ppm \
      cp -a /tmp/ppm / \
      && curl -o /usr/local/bin/docker-entrypoint \
      https://raw.githubusercontent.com/php-pm/php-pm-docker/master/build/run-ppm.sh \
      && chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
