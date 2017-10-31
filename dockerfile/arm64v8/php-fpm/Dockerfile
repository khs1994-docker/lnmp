FROM arm64v8/php:7.1.11-fpm

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

# cn

COPY ./sources.list /etc/apt/sources.list

RUN set -xe \
	      && buildDeps=" \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libsasl2-dev \
        libssl-dev \
        libmemcached-dev \
        libpq-dev \
        zlib1g-dev \
	" \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -r /var/lib/apt/lists/* \
    	   && docker-php-ext-install -j$(nproc) bcmath iconv mcrypt pdo_pgsql pdo_mysql pdo_sqlite zip \
    	   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    	   && docker-php-ext-install -j$(nproc) gd \
         && pecl install mongodb \
         && pecl install redis \
         && pecl install memcached \
         && pecl install xdebug \
         && docker-php-ext-enable mongodb memcached redis xdebug

# install composer

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
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && composer global require "laravel/installer" \
    && ln -sf /tmp/vendor/laravel/installer/laravel /usr/local/bin/ \
    && rm -rf /tmp/cache /tmp/.htaccess

WORKDIR /app
