# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994
ARG BASE=composer

FROM alpine as downloader

# https://github.com/phpmd/phpmd

ARG PHPMD_VERSION=2.9.1

RUN set -x ; apk add --no-cache curl \
    && curl -fsSL https://github.com/phpmd/phpmd/releases/download/${PHPMD_VERSION}/phpmd.phar \
         -o /usr/local/bin/phpmd \
    && chmod +x /usr/local/bin/phpmd

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

COPY --from=downloader /usr/local/bin/phpmd /usr/local/bin/phpmd

ENTRYPOINT ["phpmd"]
