# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.3.24
ARG USERNAME=khs1994
ARG BASE=composer

FROM alpine as downloader

# Sami an API documentation generator https://github.com/FriendsOfPHP/Sami

RUN set -x ; apk add --no-cache curl \
    && curl -fsSL http://get.sensiolabs.org/sami.phar -o /usr/local/bin/sami \
    && chmod +x /usr/local/bin/sami

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

COPY --from=downloader /usr/local/bin/sami /usr/local/bin/sami

ENTRYPOINT ["sami"]
