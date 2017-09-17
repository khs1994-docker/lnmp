FROM php:fpm

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

#COPY ./sources.list /etc/apt/sources.list

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

RUN rm -r /var/lib/apt/lists/*

WORKDIR /app
