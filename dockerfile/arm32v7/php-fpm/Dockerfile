FROM arm32v7/php:7.2.3-fpm-stretch@sha256:19fbcb6a003ebe662e8fe6248c16ae290eb09fcea8445b8ca2d964a27db1604b

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ENV TZ=Asia/Shanghai

ARG DEB_URL=deb.debian.org

ARG DEB_SECURITY_URL=security.debian.org

RUN sed -i "s!deb.debian.org!${DEB_URL}!g" /etc/apt/sources.list \
    && sed -i "s!security.debian.org!${DEB_SECURITY_URL}!g" /etc/apt/sources.list \
    && set -xe \
	      && buildDeps=" \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libsasl2-dev \
        libssl-dev \
        libmemcached-dev \
        libpq-dev \
        libzip-dev \
        libyaml-dev \
	" \
  && runDeps=" \
       libfreetype6 \
       libjpeg62-turbo \
       libpng16-16 \
       libssl1.1 \
       libmemcachedutil2 \
       libpq5 \
       libzip4 \
       libyaml-0-2 \
  " \
  && apt-get update && apt-get install -y $buildDeps $runDeps --no-install-recommends && rm -r /var/lib/apt/lists/* \
        && docker-php-ext-configure zip \
                                    --with-libzip \
        && docker-php-ext-configure gd \
                                    --with-freetype-dir=/usr/include/ \
                                    --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j"$(nproc)" bcmath \
                                               pdo_pgsql \
                                               pdo_mysql \
                                               zip \
                                               gd \
                                               pcntl \
        && pecl install mongodb \
                        igbinary \
                        redis \
                        memcached \
                        # 安装测试版的扩展，可以在扩展名后加 -beta
                        xdebug \
                        yaml \
                        swoole \
        && docker-php-ext-enable mongodb \
                                 redis \
                                 memcached \
                                 xdebug \
                                 yaml \
                                 igbinary \
                                 # opcache 已默认安装，需要自行载入
                                 opcache \
                                 swoole \
        && apt-get purge -y --auto-remove  $buildDeps \
        && rm -rf /tmp/*

# install composer

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=1.6.3 \
    PS1="[\u@\h \w]# "

# https://github.com/composer/docker

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
 && curl -fsSL https://raw.githubusercontent.com/composer/docker/master/1.6/docker-entrypoint.sh > /docker-entrypoint.composer.sh \
 && chmod +x /docker-entrypoint.composer.sh \
 # composer 中国镜像
 && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
 # laravel 安装程序
 && composer global require "laravel/installer" \
 && ln -sf /tmp/vendor/laravel/installer/laravel /usr/local/bin/ \
 && rm -rf /tmp/cache /tmp/.htaccess /tmp/installer.php /tmp/*.pub \
 # 默认不启用 xdebug
 && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default \
 # 创建日志文件夹
 && mkdir -p /var/log/php-fpm \
 && ln -sf /dev/stdout /var/log/php-fpm/access.log \
 && ln -sf /dev/stderr /var/log/php-fpm/error.log \
 && ln -sf /dev/stderr /var/log/php-fpm/xdebug-remote.log \
 && chmod -R 777 /var/log/php-fpm

WORKDIR /app
