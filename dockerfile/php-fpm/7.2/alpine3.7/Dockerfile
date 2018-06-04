ARG PHP_VERSION=7.2.6

FROM php:${PHP_VERSION}-fpm-alpine3.7

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ENV TZ=Asia/Shanghai \
    APP_ENV=development

# 构建变量默认值为原始值，笔记本构建统一使用 docker-compose 构建
# 国内镜像地址在 docker-compose.yml 中定义

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    && set -xe \
      # 新增的包
      && KHS1994_PHP_FPM_APKS=" \
                            git \
                            # 以下两个均为版本控制系统
                            # subversion \
                            # mercurial \
                            openssh-client \
                            bash \
                            tini \
                            tzdata \
                            " \
      # 不要删除
      && KHS1994_PHP_FPM_RUN_DEPS=" \
                         libmemcached \
                         libpq \
                         libzip \
                         libpng \
                         freetype \
                         libjpeg-turbo \
                         yaml \
                         " \
      # *-dev 编译之后删除
      && KHS1994_PHP_FPM_BUILD_DEPS=" \
                         libressl-dev \
                         libmemcached-dev \
                         cyrus-sasl-dev \
                         postgresql-dev \
                         libzip-dev \
                         libpng-dev \
                         freetype-dev \
                         libjpeg-turbo-dev \
                         yaml-dev \
                         " \
        && apk add --no-cache --virtual .khs1994-php-fpm-run-deps $KHS1994_PHP_FPM_RUN_DEPS \
        && apk add --no-cache linux-headers \
        && apk add --no-cache --virtual .khs1994-php-fpm-apks $KHS1994_PHP_FPM_APKS \
        && apk add --no-cache --virtual .khs1994-php-fpm-build-deps $KHS1994_PHP_FPM_BUILD_DEPS \
        && docker-php-ext-configure zip \
                                    --with-libzip \
        && docker-php-ext-configure gd \
                                    --disable-gd-jis-conv \
                                    --with-freetype-dir=/usr/include/ \
                                    --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j"$(nproc)" bcmath \
                                               pdo_pgsql \
                                               pdo_mysql \
                                               zip \
                                               gd \
                                               pcntl \
        && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
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
        && apk del .build-deps linux-headers .khs1994-php-fpm-build-deps \
        && rm -rf /tmp/*
        # config opcache
        # && echo 'opcache.enable_cli=1' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini \
        # && echo 'opcache.file_cache=/tmp' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini

# install composer

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=1.6.5 \
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
 && composer global require --prefer-dist "laravel/installer" \
 # php-cs-fixer
 # https://github.com/FriendsOfPHP/PHP-CS-Fixer
 && composer global require --prefer-dist "friendsofphp/php-cs-fixer" \
 # Sami an API documentation generator
 # https://github.com/FriendsOfPHP/Sami
 && curl -fsSL http://get.sensiolabs.org/sami.phar > /usr/local/bin/sami \
 && ln -sf /tmp/vendor/bin/* /usr/local/bin \
 && chmod +x /usr/local/bin/sami \
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
