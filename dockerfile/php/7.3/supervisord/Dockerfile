ARG PHP_VERSION=7.3.17
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine

ARG VCS_REF="unknow"

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

RUN apk add --no-cache supervisor

CMD ["/usr/bin/supervisord","-n"]
