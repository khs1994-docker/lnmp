# syntax=docker/dockerfile:labs

ARG PHP_VERSION=8.0.25
ARG USERNAME=khs1994
ARG BASE=composer

FROM alpine as downloader

# Sami an API documentation generator https://github.com/FriendsOfPHP/Sami
# Doctum, a PHP API documentation generator. Fork of Sami https://github.com/code-lts/doctum

ARG DOCTUM_VERSION=5.5.1

RUN set -x ; apk add --no-cache curl \
    && curl -fsSL https://doctum.long-term.support/releases/${DOCTUM_VERSION}/doctum.phar -o /usr/local/bin/doctum \
    && chmod +x /usr/local/bin/doctum

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

COPY --from=downloader /usr/local/bin/doctum /usr/local/bin/doctum

ENTRYPOINT ["doctum"]
