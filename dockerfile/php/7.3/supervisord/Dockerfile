ARG PHP_VERSION=7.3.24
ARG USERNAME=khs1994
ARG BASE=fpm

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

RUN apk add --no-cache supervisor

CMD ["/usr/bin/supervisord","-n"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
