#
# TEST PHP PROJECT BY Docker
#

ARG PHP_VERSION=7.4.12
ARG GIT_REPO={{ EXAMPLE_GIT_URL_EXAMPLE }}/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }}.git

FROM khs1994/php:${PHP_VERSION}-composer-alpine

RUN git clone --recursive --depth=1 ${GIT_REPO} /workspace \
    && cd /workspace \
    && composer install -q \
    && composer update -q \
    && vendor/bin/phpunit
