FROM php:fpm

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

COPY ./sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    		        libfreetype6-dev \
    		        libjpeg62-turbo-dev \
    		        libmcrypt-dev \
    		        libpng12-dev \
                    libsasl2-dev \
                    libssl-dev \
                    libmemcached-dev \
                    zlib1g-dev \
                    libpq-dev \
           && rm -r /var/lib/apt/lists/* \
    	   && docker-php-ext-install -j$(nproc) iconv mcrypt \
    	   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    	   && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install pdo_pgsql

RUN docker-php-ext-install pdo_mysql

RUN pecl install mongodb \
         && pecl install redis \
         && pecl install memcached \
         && pecl install xdebug \
         && docker-php-ext-enable mongodb memcached redis xdebug

# composer

RUN docker-php-ext-install zip

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.5.2

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
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
 && rm -rf /tmp/* /tmp/.htaccess

RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

RUN composer global require "laravel/installer"

RUN ln -sf /tmp/vendor/laravel/installer/laravel /usr/local/bin/

WORKDIR /app
