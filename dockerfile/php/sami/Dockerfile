# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.3.18
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-composer-alpine

# Sami an API documentation generator https://github.com/FriendsOfPHP/Sami

RUN curl -fsSL http://get.sensiolabs.org/sami.phar > /usr/local/bin/sami \
    && chmod +x /usr/local/bin/sami

ENTRYPOINT ["sami"]
