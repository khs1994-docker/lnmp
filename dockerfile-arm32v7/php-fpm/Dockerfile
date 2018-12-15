# https://sources.debian.org/src/php7.2/7.2.4-1/debian/control/

ARG PHP_VERSION=7.2.13

FROM arm32v7/php:${PHP_VERSION}-fpm-stretch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ENV TZ=Asia/Shanghai

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

ARG DEB_URL=deb.debian.org

ARG DEB_SECURITY_URL=security.debian.org/debian-security

RUN sed -i "s!deb.debian.org!${DEB_URL}!g" /etc/apt/sources.list \
    && sed -i "s!security.debian.org/debian-security!${DEB_SECURITY_URL}!g" /etc/apt/sources.list \
    && set -xe \
	      && buildDeps=" \
        wget \
        unzip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libsasl2-dev \
        libssl-dev \
        libmemcached-dev \
        libpq-dev \
        libzip-dev \
        libyaml-dev \
        libxmlrpc-epi-dev \
        libbz2-dev \
        libexif-dev \
        libgmp-dev \
        libicu-dev \
        libwebp-dev \
        libxpm-dev \
        libenchant-dev \
        libxslt1-dev \
        libc-client2007e-dev \
        libkrb5-dev \
	" \
  # libtidy-dev \
  && runDeps=" \
       libfreetype6 \
       libjpeg62-turbo \
       libpng16-16 \
       libssl1.1 \
       libmemcached11 \
       libmemcachedutil2 \
       libpq5 \
       libzip4 \
       libyaml-0-2 \
       libxslt1.1 \
       libxmlrpc-epi0 \
       libbz2-1.0 \
       libexif12 \
       libgmp10 \
       libicu57 \
       libxpm4 \
       libwebp6 \
       libenchant1c2a \
       libc-client2007e \
       libkrb5-3 \
  " \
  # libtidy5 \
  && apt-get update && apt-get install -y $buildDeps $runDeps --no-install-recommends && rm -r /var/lib/apt/lists/* \
        && docker-php-ext-configure zip \
                                    --with-libzip \
        && docker-php-ext-configure gd \
                                    --disable-gd-jis-conv \
                                    --with-freetype-dir=/usr \
                                    --with-jpeg-dir=/usr \
                                    --with-png-dir=/usr \
                                    --with-webp-dir=/usr \
                                    --with-xpm-dir=/usr \
        # https://stackoverflow.com/questions/13436356/configure-error-utf8-mime2text-has-new-signature-but-u8t-canonical-is-missi
        && docker-php-ext-configure imap \
                                    --with-kerberos \
                                    --with-imap-ssl \
        && docker-php-ext-install $PHP_EXTENSION \
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
        && apt-get purge -y --auto-remove  $buildDeps \
        && rm -rf /tmp/* \
        # config opcache
        # && echo 'opcache.enable_cli=1' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini \
        # && echo 'opcache.file_cache=/tmp' >> ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini
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

# install composer

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=1.8.0 \
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
