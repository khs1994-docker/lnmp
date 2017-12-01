FROM php:7.2.0-fpm-alpine3.6

ENV TZ=Asia/Shanghai

# 替换源

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

ENV KHS1994_PHP_FPM_DEPS \
                         git \
                         subversion \
                         openssh \
                         mercurial \
                         tini \
                         bash \
                         freetype-dev \
                         libjpeg-turbo-dev \
                         libpng-dev \
                         libressl-dev \
                         libmemcached-dev \
                         cyrus-sasl-dev \
                         postgresql-dev \
                         zlib-dev \
                         tzdata \
                         sqlite-dev

RUN set -xe \
        && apk add --no-cache $KHS1994_PHP_FPM_DEPS \
        && docker-php-ext-install -j "$(nproc)" bcmath iconv pdo_pgsql pdo_mysql pdo_sqlite zip \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j "$(nproc)" gd \
        && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        && pecl install mongodb redis memcached \
        # xdebug 目前不支持 7.2 \
        && docker-php-ext-enable mongodb redis memcached \
        # xdebug 目前不支持 7.2 \
        && apk del .build-deps

# install composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.5.2

RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
    && echo "date.timezone=${PHP_TIMEZONE:-PRC}" > "$PHP_INI_DIR/conf.d/date_timezone.ini" \
    && curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
    && php -r " \
    \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
 && composer global require "laravel/installer" \
 && ln -sf /tmp/vendor/laravel/installer/laravel /usr/local/bin/ \
 && rm -rf /tmp/cache /tmp/.htaccess \
 && echo > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/log

RUN mkdir php-fpm \
 && cd php-fpm \
 && touch access.log error.log xdebug-remote.log \
 && chmod -R 777 ../ \
 && sed -i 's/www-data/root/g' /usr/local/etc/php-fpm.d/www.conf \
 && sed -i 's/^error_log.*/error_log = \/var\/log\/php-fpm\/error.log/g' /usr/local/etc/php-fpm.d/docker.conf \
 && sed -i 's/^access.log.*/access.log = \/var\/log\/php-fpm\/access.log/g' /usr/local/etc/php-fpm.d/docker.conf

ENV PS1="[\u@\h \w]# "

# RUN apk add --no-cache vim

WORKDIR /app
