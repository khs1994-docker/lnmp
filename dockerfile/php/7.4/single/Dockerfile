ARG PHP_VERSION=7.4.12

FROM --platform=$TARGETPLATFORM php:${PHP_VERSION}-fpm-alpine3.11

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ENV TZ=Asia/Shanghai \
    APP_ENV=development

# ARG ALPINE_URL=dl-cdn.alpinelinux.org

ARG ALPINE_URL=mirrors.aliyun.com

RUN set -x ; sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories

RUN set -x ; apk add --no-cache bash tzdata

RUN set -x && curl -fsSL -o /usr/local/bin/pickle \
        https://github.com/khs1994-php/pickle/releases/download/nightly/pickle-debug.phar \
    && chmod +x /usr/local/bin/pickle

RUN set -x ; apk add --no-cache --virtual .build-deps $PHPIZE_DEPS

RUN set -x \
    && apk add --no-cache libzip \
    && apk add --no-cache --virtual .ext-build-deps libzip-dev \
    && docker-php-source extract \
#    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x ; \
    docker-php-source extract \
    && pickle install sockets -n --defaults --strip \
    && docker-php-source delete

RUN set -x ; \
    docker-php-source extract \
    && pickle install sysvmsg -n --defaults --strip \
    && docker-php-source delete

RUN set -x ; \
    docker-php-source extract \
    && pickle install sysvsem -n --defaults --strip \
    && docker-php-source delete

RUN set -x ; \
    docker-php-source extract \
    && pickle install sysvshm -n --defaults --strip \
    && docker-php-source delete

RUN set -x ; \
    docker-php-source extract \
    && pickle install shmop -n --defaults --strip \
    && docker-php-source delete

# RUN set -x \
#     && docker-php-source extract \
#     && apk add --no-cache PKG \
#     && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#     && echo "" > /tmp/EXT.configure.options \
#     && pickle install EXT -n --defaults --strip \
#     && apk del --no-network .ext-build-deps \
#     && docker-php-source delete \
#     && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache libpng \
                          freetype \
                          libjpeg-turbo \
                          # libxpm \
                          libwebp \
                          zlib \
    && apk add --no-cache --virtual .ext-build-deps  \
                                      libpng-dev \
                                      freetype-dev \
                                      libjpeg-turbo-dev \
                                      # libxpm-dev \
                                      libwebp-dev \
                                      zlib-dev \
    && echo "--disable-gd-jis-conv \
--with-freetype \
--with-jpeg \
--with-webp \
--with-xpm=no" > /tmp/gd.configure.options \
    && pickle install gd -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
     && docker-php-source extract \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/pdo_mysql.configure.options \
    && pickle install pdo_mysql -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
     && docker-php-source extract \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/mysqli.configure.options \
    && pickle install mysqli -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
     && docker-php-source extract \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/calendar.configure.options \
    && pickle install calendar -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
     && docker-php-source extract \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/pcntl.configure.options \
    && pickle install pcntl -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache libffi \
    && apk add --no-cache --virtual .ext-build-deps libffi-dev \
#    && echo "" > /tmp/ffi.configure.options \
    && pickle install ffi -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache libpq \
    && apk add --no-cache --virtual .ext-build-deps postgresql-dev \
#    && echo "" > /tmp/pdo_pgsql.configure.options \
    && pickle install pdo_pgsql pgsql -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache gmp \
    && apk add --no-cache --virtual .ext-build-deps gmp-dev \
#    && echo "" > /tmp/gmp.configure.options \
    && pickle install gmp -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache libexif \
    && apk add --no-cache --virtual .ext-build-deps libexif-dev \
#    && echo "" > /tmp/exif.configure.options \
    && pickle install exif -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache enchant \
    && apk add --no-cache --virtual .ext-build-deps enchant-dev \
#    && echo "" > /tmp/enchant.configure.options \
    && pickle install enchant -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache libxslt \
    && apk add --no-cache --virtual .ext-build-deps libxslt-dev \
#    && echo "" > /tmp/xsl.configure.options \
    && pickle install xsl -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache c-client \
    && apk add --no-cache --virtual .ext-build-deps imap-dev \
#    && echo "" > /tmp/imap.configure.options \
    && pickle install imap -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache libbz2 \
    && apk add --no-cache --virtual .ext-build-deps bzip2-dev \
#    && echo "" > /tmp/bz2.configure.options \
    && pickle install bz2 -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
#    && apk add --no-cache PKG \
    && apk add --no-cache --virtual .ext-build-deps gettext-dev \
#    && echo "" > /tmp/gettext.configure.options \
    && pickle install gettext -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache icu-libs \
    && apk add --no-cache --virtual .ext-build-deps icu-dev \
#    && echo "" > /tmp/intl.configure.options \
    && pickle install intl -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
    && docker-php-source extract \
    && apk add --no-cache tidyhtml-libs \
    && apk add --no-cache --virtual .ext-build-deps tidyhtml-dev \
#    && echo "" > /tmp/tidy.configure.options \
    && pickle install tidy -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && docker-php-source delete \
    && rm -rf /tmp/*

RUN set -x \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/mongodb.configure.options \
    && pickle install mongodb -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/igbinary.configure.options \
    && pickle install igbinary -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
    && apk add --no-cache zstd-libs \
    && apk add --no-cache --virtual .ext-build-deps zstd-dev \
    && echo "--enable-redis-igbinary --enable-redis-zstd" > /tmp/redis.configure.options \
    && pickle install redis -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
    && apk add --no-cache libmemcached-libs \
    && apk add --no-cache --virtual .ext-build-deps \
                                    libmemcached-dev \
                                    cyrus-sasl-dev \
                                    zlib-dev \
    && echo "--enable-memcached-igbinary" > /tmp/memcached.configure.options \
    && pickle install memcached -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
    && apk add --no-cache yaml \
    && apk add --no-cache --virtual .ext-build-deps yaml-dev \
#    && echo "" > /tmp/yaml.configure.options \
    && pickle install yaml -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/xdebug.configure.options \
    && pickle install xdebug -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
#    && apk add --no-cache PKG \
#    && apk add --no-cache --virtual .ext-build-deps PKG-dev \
#    && echo "" > /tmp/EXT.configure.options \
    && pickle install https://github.com/tideways/php-xhprof-extension/archive/master.tar.gz -n --defaults --strip \
#    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

RUN set -x \
    && apk add --no-cache nghttp2-libs \
    && apk add --no-cache --virtual .ext-build-deps \
                                    openssl-dev \
                                    nghttp2-dev \
    && echo " \
--with-php-config=php-config \
--enable-openssl \
--enable-sockets \
--enable-http2 \
--enable-mysqlnd \
" > /tmp/swoole.configure.options \
    && pickle install swoole -n --defaults --strip \
    && apk del --no-network .ext-build-deps \
    && rm -rf /tmp/*

# 创建日志文件夹
RUN mkdir -p /var/log/php-fpm \
      && ln -sf /dev/stdout /var/log/php-fpm/access.log \
      && ln -sf /dev/stderr /var/log/php-fpm/error.log \
      && ln -sf /dev/stderr /var/log/php-fpm/xdebug-remote.log \
      && chmod -R 777 /var/log/php-fpm

WORKDIR /app

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"

RUN set -x ; php -m || true
