ARG PHP_VERSION=7.2.28

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-fpm-alpine

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

RUN apk add --no-cache supervisor

CMD ["/usr/bin/supervisord","-n"]
