FROM arm32v7/php:7.2.2-fpm-stretch

ENV TZ=Asia/Shanghai
# cn

COPY ./sources.list /etc/apt/sources.list

RUN set -xe \
	      && buildDeps=" \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libsasl2-dev \
        libssl-dev \
        libmemcached-dev \
        libpq-dev \
        libzip-dev \
	" \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -r /var/lib/apt/lists/* \
	       && docker-php-ext-configure zip \
				                             --with-libzip \
         && docker-php-ext-configure gd \
                                     --with-freetype-dir=/usr/include/ \
                                     --with-jpeg-dir=/usr/include/ \
    	   && docker-php-ext-install -j"$(nproc)" bcmath \
				                                        pdo_pgsql \
																							  pdo_mysql \
																							  opcache \
                                                zip \
                                                gd \
         && pecl install mongodb \
				                 redis \
												 memcached \
												 xdebug \
         && docker-php-ext-enable mongodb \
				                          memcached \
																	redis \
																	xdebug \
         && rm -rf /tmp/*

# install composer

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=1.6.3

RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
    && echo "date.timezone=${PHP_TIMEZONE:-PRC}" > "$PHP_INI_DIR/conf.d/date_timezone.ini" \
    && curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
    && php -r " \
    \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 # composer 中国镜像
 && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
 # laravel 安装程序
 && composer global require "laravel/installer" \
 && ln -sf /tmp/vendor/laravel/installer/laravel /usr/local/bin/ \
 && rm -rf /tmp/cache /tmp/.htaccess /tmp/installer.php /tmp/*.pub \
 # 默认不启用 xdebug
 && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default \
 # 创建日志文件夹
 && cd /var/log \
 && mkdir php-fpm \
 && cd php-fpm \
 && touch access.log error.log xdebug-remote.log \
 && chmod -R 777 ../ \
 && sed -i 's/www-data/root/g' /usr/local/etc/php-fpm.d/www.conf \
 && sed -i 's/^error_log.*/error_log = \/var\/log\/php-fpm\/error.log/g' /usr/local/etc/php-fpm.d/docker.conf \
 && sed -i 's/^access.log.*/access.log = \/var\/log\/php-fpm\/access.log/g' /usr/local/etc/php-fpm.d/docker.conf

WORKDIR /app
