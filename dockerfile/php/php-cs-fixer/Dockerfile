# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.4.3

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-composer-alpine

# php-cs-fixer https://github.com/FriendsOfPHP/PHP-CS-Fixer

ENV PHP_CS_FIXER_VERSION=2.16.1 \
    PHP_CS_FIXER_IGNORE_ENV=1

RUN curl -fsSL https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${PHP_CS_FIXER_VERSION}/php-cs-fixer.phar > /usr/local/bin/php-cs-fixer \
    && chmod +x /usr/local/bin/php-cs-fixer

ENTRYPOINT ["php-cs-fixer"]
