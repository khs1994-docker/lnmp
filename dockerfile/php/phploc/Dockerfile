# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.4.11
ARG USERNAME=khs1994
ARG BASE=composer

FROM alpine as downloader

# Copy/Paste Detector (CPD) for PHP code.  https://github.com/sebastianbergmann/phploc

ENV PHPLOC_VERSION=7.0.1

RUN set -x ; apk add --no-cache curl \
    && curl -fsSL https://phar.phpunit.de/phploc-${phploc_VERSION}.phar -o /usr/local/bin/phploc \
    && chmod +x /usr/local/bin/phploc

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

COPY --from=downloader /usr/local/bin/phploc /usr/local/bin/phploc

ENTRYPOINT ["phploc"]
