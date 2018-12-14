# https://git.alpinelinux.org/cgit/aports/tree/community/php7/APKBUILD

ARG PHP_VERSION=7.2.13

FROM arm64v8/php:${PHP_VERSION}-fpm-alpine as php

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG PHP_EXTENSION_EXTRA

ARG PECL_EXTENSION_EXTRA

ARG APK_EXTRA

ARG APK_DEV_EXTRA

ENV TZ=Asia/Shanghai \
    APP_ENV=development

ENV PHP_EXTENSION \
      bcmath \
      bz2 \
      calendar \
      enchant \
      exif \
      gd \
      gettext \
      gmp \
      imap \
      intl \
      mysqli \
      pcntl \
      pdo_pgsql \
      pdo_mysql \
      pgsql \
      sockets \
      sysvmsg \
      sysvsem \
      sysvshm \
# tidy \
      xmlrpc \
      xsl \
      zip

ENV PECL_EXTENSION \
      mongodb \
      igbinary \
      redis \
      memcached \
# 安装测试版的扩展，可以在扩展名后加 -beta
      xdebug \
      yaml \
      swoole

# 构建变量默认值为原始值，笔记本构建统一使用 docker-compose 构建
# 国内镜像地址在 docker-compose.yml 中定义

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
      && set -xe \
      # 不要删除
      && PHP_FPM_RUN_DEPS=" \
                         bash \
                         tzdata \
                         libmemcached \
                         libpq \
                         libzip \
                         libpng \
                         freetype \
                         libjpeg-turbo \
                         yaml \
                         libbz2 \
                         libexif \
                         libxslt \
                         gmp \
                         xmlrpc-c \
                         enchant \
                         c-client \
                         libwebp \
                         icu-libs \
                         libxpm \
                         libwebp \
                         " \
                         # tidyhtml-libs \
      # *-dev 编译之后删除
      && PHP_FPM_BUILD_DEPS=" \
                         libressl-dev \
                         libmemcached-dev \
                         cyrus-sasl-dev \
                         postgresql-dev \
                         libzip-dev \
                         libpng-dev \
                         freetype-dev \
                         libjpeg-turbo-dev \
                         yaml-dev \
                         libexif-dev \
                         libxslt-dev \
                         gmp-dev \
                         xmlrpc-c-dev \
                         bzip2-dev \
                         enchant-dev \
                         imap-dev \
                         gettext-dev \
                         libwebp-dev \
                         icu-dev \
                         libxpm-dev \
                         libwebp-dev \
                         " \
                         # tidyhtml-dev \
        && apk add --no-cache --virtual .php-fpm-run-deps $PHP_FPM_RUN_DEPS \
        && apk add --no-cache --virtual .php-fpm-build-deps $PHP_FPM_BUILD_DEPS \
        && docker-php-ext-configure zip \
                                    --with-libzip \
        && docker-php-ext-configure gd \
                                        --disable-gd-jis-conv \
                                        --with-freetype-dir=/usr \
                                        --with-jpeg-dir=/usr \
                                        --with-png-dir=/usr \
                                        --with-webp-dir=/usr \
                                        --with-xpm-dir=/usr \
        && docker-php-ext-install $PHP_EXTENSION \
        && apk add --no-cache --virtual .build-deps linux-headers $PHPIZE_DEPS \
        && for extension in $PECL_EXTENSION;do \
             pecl install $extension \
               && docker-php-ext-enable $(echo ${extension} | cut -d '-' -f 1) || echo "pecl ${extension} install error"; \
           done \
        # https://github.com/tideways/php-xhprof-extension.git
        && cd /tmp \
        && wget https://github.com/tideways/php-xhprof-extension/archive/master.zip \
        && unzip master.zip \
        && cd php-xhprof-extension-master \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && docker-php-ext-enable opcache tideways_xhprof \
        && apk del --no-cache .build-deps .php-fpm-build-deps \
        && rm -rf /tmp/* \
        # 默认不启用 xdebug
        && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
          /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.default \
        && mv /usr/local/etc/php/conf.d/docker-php-ext-tideways_xhprof.ini \
          /usr/local/etc/php/conf.d/docker-php-ext-tideways_xhprof.ini.default \
        # 创建日志文件夹
        && mkdir -p /var/log/php-fpm \
        && ln -sf /dev/stdout /var/log/php-fpm/access.log \
        && ln -sf /dev/stderr /var/log/php-fpm/error.log \
        && ln -sf /dev/stderr /var/log/php-fpm/xdebug-remote.log \
        && chmod -R 777 /var/log/php-fpm
        # config opcache
        # && echo 'opcache.enable_cli=1' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini \
        # && echo 'opcache.file_cache=/tmp' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini

# install composer

ENV COMPOSER_DEP_APKS \
      git \
      # 以下两个均为版本控制系统
      # subversion \
      # mercurial \
      openssh-client \
      tini

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=1.8.0 \
    PS1="[\u@\h \w]# "

# https://github.com/composer/docker

RUN apk add --no-cache --virtual .php-fpm-apks $COMPOSER_DEP_APKS \
    && echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
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
 && curl -fsSL https://raw.githubusercontent.com/composer/docker/master/1.7/docker-entrypoint.sh > /docker-entrypoint.composer.sh \
 && chmod +x /docker-entrypoint.composer.sh \
 \
 # composer 中国镜像
 && composer config -g repo.packagist composer https://packagist.laravel-china.org \
 \
 # laravel 安装程序
 && composer global require --prefer-dist "laravel/installer" \
 \
 # php-cs-fixer
 # https://github.com/FriendsOfPHP/PHP-CS-Fixer
 && composer global require --prefer-dist "friendsofphp/php-cs-fixer" \
 \
 # Sami an API documentation generator
 # https://github.com/FriendsOfPHP/Sami
 && curl -fsSL http://get.sensiolabs.org/sami.phar > /usr/local/bin/sami \
 && chmod +x /usr/local/bin/sami \
 \
 && ln -sf /tmp/vendor/bin/* /usr/local/bin \
 && rm -rf /tmp/cache /tmp/.htaccess /tmp/installer.php /tmp/*.pub

WORKDIR /app
