FROM debian:buster-slim

################################################################################

ARG PHP_VERSION=7.4.12

ARG PHP_NUM=74

ARG PHP_PREFIX=/usr/local/php73

ARG PHP_INI_DIR=/usr/local/etc/php73

ARG COMPOSER_VERSION=1.8.5

ENV COMPOSER_ALLOW_SUPERUSER=1

ENV COMPOSER_HOME=/tmp/composer

ENV TZ Asia/Shanghai

################################################################################

ARG DEB_URL=deb.debian.org

# mirrors.ustc.edu.cn

ARG DEB_SECURITY_URL=security.debian.org

# mirrors.ustc.edu.cn/debian-security/

COPY --from=php /usr/local/bin/docker-php-source /usr/local/bin/

COPY --from=php /usr/local/bin/docker-php-ext-* /usr/local/bin/docker-php-entrypoint /usr/local/bin/

COPY wsl-php-ext-enable.sh /usr/local/bin/wsl-php-ext-enable.sh

ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

ENV PHP_URL="https://www.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror"

ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    re2c

RUN sed -i "s!deb.debian.org!${DEB_URL}!g" /etc/apt/sources.list \
        && sed -i "s!security.debian.org!${DEB_SECURITY_URL}!g" /etc/apt/sources.list \
        && set -eux; \
      { \
        echo 'Package: php*'; \
        echo 'Pin: release *'; \
        echo 'Pin-Priority: -1'; \
      } > /etc/apt/preferences.d/no-debian-php \
  && apt update && apt-get install -y --no-install-recommends \
    libargon2-0 \
    libargon2-0-dev \
    libbz2-1.0 \
    libbz2-dev \
    libc-client2007e \
    libc-client2007e-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libedit-dev \
    libenchant1c2a \
    libenchant-dev \
    # libsodium18 \
    libsodium23 \
    libsodium-dev \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl1.1 \
    libssl-dev \
    libxml2 \
    libxml2-dev \
    zlib1g \
    zlib1g-dev \
    libxslt1.1 \
    libxslt1-dev \
    libfreetype6 \
    libfreetype6-dev \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libpng16-16 \
    libpng-dev \
    libsasl2-2 \
    libsasl2-dev \
    libmemcached11 \
    libmemcachedutil2 \
    libmemcached-dev \
    libpq5 \
    libpq-dev \
    libzip4 \
    libzip-dev \
    libyaml-0-2 \
    libyaml-dev \
    ${PHP_EXTRA_BUILD_DEPS:-} \
    $PHPIZE_DEPS \
    ca-certificates \
    curl \
    tar \
    wget \
    xz-utils \
    # libtidy5 \
    libtidy5deb1 \
    libtidy-dev \
    # libxmlrpc-epi0 \
    # libxmlrpc-epi-dev \
    libexif12 \
    libexif-dev \
    libgmp10 \
    libgmp-dev \
    libc-client2007e-dev \
    libc-client2007e \
    libkrb5-3 \
    libkrb5-dev \
    libxpm4 \
    libxpm-dev \
    libwebp6 \
    libwebp-dev \
    libldap-2.4-2 \
    libldap2-dev \
    libpspell-dev \
    # libsnmp30 \
    # libsnmp-dev \
    # snmp \
    libmhash2 \
    libmhash-dev \
    libpcre3 \
    libpcre3-dev \
    # libicu57 \
    libicu63 \
    libicu-dev \
    libonig5 \
    libonig-dev \
    libffi6 \
    libffi-dev \
  && mkdir -p $PHP_INI_DIR/conf.d; \
      mkdir -p /usr/src; \
      cd /usr/src; \
      wget -O php.tar.xz "$PHP_URL" \
  && set -eux; \
  savedAptMark="$(apt-mark showmanual)"; \
  export \
    CFLAGS="$PHP_CFLAGS" \
    CPPFLAGS="$PHP_CPPFLAGS" \
    LDFLAGS="$PHP_LDFLAGS" \
  && docker-php-source extract; \
  cd /usr/src/php; \
  gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
  debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
  # https://bugs.php.net/bug.php?id=74125
  if [ ! -d /usr/include/curl ]; then \
    ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
  fi; \
  # X https://www.howtoforge.com/tutorial/how-to-install-php-7-on-debian/
  # https://stackoverflow.com/questions/34272444/compiling-php7-error
  ln -sf /usr/lib/libc-client.so.2007e.0 /usr/lib/x86_64-linux-gnu/libc-client.a; \
  # https://stackoverflow.com/questions/43617752/docker-php-and-freetds-cannot-find-freetds-in-know-installation-directories
  # ln -sf /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ ; \
  ./configure \
    --prefix=${PHP_PREFIX} \
    --sysconfdir=${PHP_INI_DIR} \
    --build="$gnuArch" \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx \
    \
    --disable-cgi \
    \
# --enable-ftp is included here because ftp_ssl_connect() needs ftp to be compiled statically
# (see https://github.com/docker-library/php/issues/236)
    --enable-ftp \
# --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly
# (see https://github.com/docker-library/php/issues/195)
    --enable-mbstring \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are
# (since it's a plugin for several extensions, not an extension in itself)
    --enable-mysqlnd \
# https://wiki.php.net/rfc/argon2_password_hash (7.2+)
    --with-password-argon2 \
# https://wiki.php.net/rfc/libsodium
    --with-sodium=shared \
    \
    --with-curl \
    --with-gettext \
    --with-gd \
        # php 7.4
        # --enable-freetype \
        --with-freetype-dir=/usr/lib \
        --disable-gd-jis-conv \
        --with-jpeg-dir=/usr/lib \
        --with-png-dir=/usr/lib \
        --with-webp-dir=/usr/lib \
        --with-xpm-dir=/usr/lib \
    --with-libedit \
    --with-openssl \
        --with-system-ciphers \
    --with-pcre-regex \
    --with-pdo-mysql \
    --with-pdo-pgsql=shared \
    --with-xsl=shared \
    --with-zlib \
    --with-mhash \
    --enable-bcmath \
    --enable-pcntl=shared \
    --enable-shmop=shared \
    --enable-soap=shared \
    --enable-sockets=shared \
    --enable-sysvmsg=shared \
    --enable-sysvsem=shared \
    --enable-sysvshm=shared \
    --enable-zip \
        --with-libzip \
    --enable-calendar=shared \
    --enable-intl=shared \
    --enable-exif \
    --with-bz2 \
    --with-tidy \
    --with-gmp \
    --with-imap=shared \
        --with-imap-ssl \
        --with-kerberos \
    # --with-xmlrpc \
    --with-pic \
    --with-enchant=shared \
    --enable-fileinfo=shared \
    --with-ldap=shared \
        --with-ldap-sasl \
    --with-pspell=shared \
    --enable-shmop=shared \
    # --with-snmp=shared \
    --enable-embed=shared \
    --with-mysqli=shared \
    --with-pgsql=shared \
    \
  # bundled pcre does not support JIT on s390x
  # https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
    $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
    --with-libdir="lib/$debMultiarch" \
    \
    ${PHP_EXTRA_CONFIGURE_ARGS:-} ; \
  make -j "$(nproc)"; \
  make install \
  && rm -rf /usr/local/sbin \
  && for file in $( ls ${PHP_PREFIX}/bin ); do ln -sf ${PHP_PREFIX}/bin/$file /usr/local/bin/ ; done \
  && pecl update-channels \
  && rm -rf /tmp/pear ~/.pearrc \
  && set -ex \
  && cd ${PHP_INI_DIR} \
  && if [ -d php-fpm.d ]; then \
    # for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
    sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
    cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
  else \
    # PHP 5.x doesn't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
    mkdir php-fpm.d; \
    cp php-fpm.conf.default php-fpm.d/www.conf; \
    { \
      echo '[global]'; \
      echo 'include=${PHP_INI_DIR}/php-fpm.d/*.conf'; \
    } | tee php-fpm.conf; \
  fi \
  && cp /usr/src/php/php.ini-* ${PHP_INI_DIR} \
  && cp ${PHP_INI_DIR}/php.ini-development ${PHP_INI_DIR}/php.ini \
  && pecl install mongodb \
                  igbinary \
                  redis \
                  memcached \
                  # 安装测试版的扩展，可以在扩展名后加 -beta
                  xdebug \
                  yaml \
                  swoole \
  && mkdir -p /usr/local/etc/php \
  && ln -s ${PHP_INI_DIR}/conf.d /usr/local/etc/php/conf.d \
  && chmod +x /usr/local/bin/wsl-php-ext-enable.sh \
  && docker-php-ext-enable mongodb \
                           redis \
                           memcached \
                           xdebug \
                           yaml \
                           igbinary \
                           # opcache 已默认安装，需要自行载入
                           opcache \
                           swoole \
                           \
                           fileinfo \
                           pdo_pgsql \
                           xsl \
                           pcntl \
                           shmop \
                           soap \
                           sockets \
                           sysvmsg \
                           sysvsem \
                           sysvshm \
                           calendar \
                           intl \
                           imap \
                           enchant \
                           ldap \
                           pspell \
                           # snmp \
                           mysqli \
                           pgsql \
  && curl -fsSL https://raw.githubusercontent.com/khs1994-docker/lnmp/master/wsl/config/php.fpm.zz-wsl.conf.example \
       > ${PHP_INI_DIR}/php-fpm.d/zz-debian.conf \
  && curl -s -f -L -o /tmp/installer.php \
         https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
  && php -r " \
    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
  && php /tmp/installer.php --no-ansi --install-dir=${PHP_PREFIX}/bin --filename=composer --version=${COMPOSER_VERSION} \
  && ${PHP_PREFIX}/bin/composer --ansi --version --no-interaction \
  && rm -rf /tmp/* \
  # config opcache
  # && echo 'opcache.enable_cli=1' >> ${PHP_INI_DIR}/conf.d/wsl-php-ext-opcache.ini \
  && echo 'opcache.file_cache=/tmp' >> ${PHP_INI_DIR}/conf.d/wsl-php-ext-opcache.ini \
  && echo "date.timezone=${PHP_TIMEZONE:-PRC}" | tee ${PHP_INI_DIR}/conf.d/date_timezone.ini \
  && echo "error_log=/var/log/php${PHP_NUM}.error.log" | tee ${PHP_INI_DIR}/conf.d/error_log.ini

      # nginx apt

      # apache other

      # mysql apt

      # mariadb apt

      # redis

COPY --from=redis:6.0.9 /usr/local/bin/redis-* ${PHP_PREFIX}/bin/

      # memcached

COPY --from=memcached:1.5.6 /usr/local/bin/memcached ${PHP_PREFIX}/bin/

      # rabbitmq apt

      # postgresql apt

      # mongodb

      # phpmyadmin

RUN cd /usr/local ; tar -zcvf php73.tar.gz php73 ; cd etc ; tar -zcvf php73-etc.tar.gz php73 \
    && for ext in $( ls /usr/src/php/ext ); \
        do echo '*' $( php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done \
    && php -v \
    && php -i | grep ".ini" \
    && ${PHP_PREFIX}/sbin/php-fpm -v

FROM scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=0 /usr/local/php73.tar.gz /

COPY --from=0 /usr/local/etc/php73-etc.tar.gz /
