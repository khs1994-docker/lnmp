# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.3.15

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-composer-alpine as composer

RUN mkdir /ppm \
      && cd /ppm \
      && composer config -g --unset repos.packagist \
      && composer require php-pm/php-pm --no-cache \
      && composer require php-pm/httpkernel-adapter --no-cache \
      && rm -rf /tmp/cache /ppm/composer*

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-cli-alpine

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

RUN --mount=type=cache,from=composer,source=/ppm,target=/tmp/ppm \
      cp -a /tmp/ppm / \
      && curl -o /usr/local/bin/docker-entrypoint \
      https://raw.githubusercontent.com/php-pm/php-pm-docker/master/build/run-ppm.sh \
      && chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
