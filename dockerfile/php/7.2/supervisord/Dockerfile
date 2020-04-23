ARG PHP_VERSION=7.2.30
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

RUN apk add --no-cache supervisor

CMD ["/usr/bin/supervisord","-n"]
