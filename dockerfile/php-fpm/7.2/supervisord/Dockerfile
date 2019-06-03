ARG PHP_VERSION=7.2.19

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-fpm-alpine as php

RUN apk add --no-cache supervisor

CMD ["/usr/bin/supervisord","-n"]
