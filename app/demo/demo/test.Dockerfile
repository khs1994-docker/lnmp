#
# http://php.net/eol.php
#

#
# TEST PHP PROJECT BY Docker
#

#
# 7.2.0+
#

ARG PHP_VERSION_7_2_X=7.2.0

#
# 7.1.0+
#

ARG PHP_VERSION_7_1_X=7.1.0

#
# 7.0.0+
#

ARG PHP_VERSION_7_0_X=7.0.0

#
# 5.6.0+
#

ARG PHP_VERSION_5_6_X=5.6.0

#
# TEST PHP VERSION 7.2.x
#

FROM khs1994/php:${PHP_VERSION_7_2_X}-fpm-alpine

RUN git clone --recursive --depth=1 {{ EXAMPLE_GIT_URL_EXAMPLE }}/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }}.git /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} \
    && cd /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} \
    && composer install -q \
    && composer update -q \
    && vendor/bin/phpunit

#
# TEST PHP VERSION 7.1.x
#

FROM khs1994/php:${PHP_VERSION_7_1_X}-fpm-alpine

COPY --from=0 /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }}

RUN cd /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} \
    && rm -rf vendor composer.lock \
    && composer install -q \
    && composer update -q \
    && vendor/bin/phpunit

#
# TEST PHP VERSION 7.0.x
#

# FROM khs1994/php:${PHP_VERSION_7_0_X}-fpm-alpine
#
# COPY --from=0 /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }}
#
# RUN cd /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} \
#       && rm -rf vendor composer.lock \
#       && composer install -q \
#       && composer update -q \
#       && vendor/bin/phpunit

#
# TEST PHP VERSION 5.6.x
#

# FROM khs1994/php:${PHP_VERSION_5_6_X}-fpm-alpine
#
# COPY --from=0 /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }}
#
# RUN cd /root/{{ EXAMPLE_GIT_USERNAME_EXAMPLE }}/{{ EXAMPLE_GIT_REPO_EXAMPLE }} \
#       && rm -rf vendor composer.lock \
#       && composer install -q \
#       && composer update -q \
#       && vendor/bin/phpunit
