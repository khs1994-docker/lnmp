ARG PHP_VERSION=7.3.5
ARG IMAGE=khs1994/php

FROM ${IMAGE}:${PHP_VERSION}-fpm-alpine as php

RUN apk add --no-cache supervisor

CMD ["/usr/bin/supervisord","-n"]
