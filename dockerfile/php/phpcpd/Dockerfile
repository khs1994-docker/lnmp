# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994
ARG BASE=composer

FROM alpine as downloader

# Copy/Paste Detector (CPD) for PHP code.  https://github.com/sebastianbergmann/phpcpd

ARG PHPCPD_VERSION=6.0.2

RUN set -x ; apk add --no-cache curl \
    && curl -fsSL https://phar.phpunit.de/phpcpd-${PHPCPD_VERSION}.phar -o /usr/local/bin/phpcpd \
    && chmod +x /usr/local/bin/phpcpd

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

COPY --from=downloader /usr/local/bin/phpcpd /usr/local/bin/phpcpd

ENTRYPOINT ["phpcpd"]
