FROM debian:stretch-slim@sha256:613efd414e9818dcef858201484a94603a548a0e04fd4356e77eb758aeb16124

################################################################################

ARG PHP_VERSION=7.2.4

ARG PHP_PREFIX=/usr/local/php72

ARG PHP_INI_DIR=/usr/local/etc/php72

ARG COMPOSER_VERSION=1.6.3

################################################################################

ARG DEB_URL=deb.debian.org

# mirrors.ustc.edu.cn

ARG DEB_SECURITY_URL=security.debian.org

# mirrors.ustc.edu.cn/debian-security/

ENV TZ Asia/Shanghai

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
		libargon2-0-dev \
		libcurl4-openssl-dev \
		libedit-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		zlib1g-dev \
    libxslt1-dev \
    #
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libsasl2-dev \
    libssl-dev \
    libmemcached-dev \
    libpq-dev \
    libzip-dev \
    libyaml-dev \
		${PHP_EXTRA_BUILD_DEPS:-} \
    #
    $PHPIZE_DEPS \
		ca-certificates \
		curl \
		xz-utils \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libsasl2-2 \
    libssl1.1 \
    libmemcachedutil2 \
    libpq5 \
    libzip4 \
    libyaml-0-2 \
    libxslt1.1 \
    tar \
    wget \
    \
    libtidy5 \
    libtidy-dev \
    libxmlrpc-epi0 \
    libxmlrpc-epi-dev \
    libbz2-1.0 \
    libbz2-dev \
    libexif12 \
    libexif-dev \
    libgmp3-dev \
    libc-client2007e \
    libc-client2007e-dev \
    libkrb5-dev

COPY --from=php /usr/local/bin/docker-php-source /usr/local/bin/

COPY --from=php /usr/local/bin/docker-php-ext-* /usr/local/bin/docker-php-entrypoint /usr/local/bin/

ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV PHP_URL="https://secure.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror"

RUN mkdir -p $PHP_INI_DIR/conf.d; \
      mkdir -p /usr/src; \
	    cd /usr/src; \
	    wget -O php.tar.xz "$PHP_URL"

RUN set -eux; \
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
  # https://www.howtoforge.com/tutorial/how-to-install-php-7-on-debian/
  ln -sf /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a; \
	./configure \
    --prefix=${PHP_PREFIX} \
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
		--with-sodium \
		\
    --with-curl \
    --with-gd \
    --with-gettext \
    --with-iconv-dir \
    --with-kerberos \
    --with-libedit \
    --with-openssl \
    --with-pcre-regex \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-xsl \
    --with-zlib \
    --with-mhash \
    --with-png-dir=/usr/lib \
    --with-jpeg-dir=/usr/lib\
    --with-freetype-dir=/usr/lib \
    --enable-bcmath \
    --enable-libxml \
    --enable-inline-optimization \
    --enable-gd-jis-conv \
    --enable-mbregex \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-sysvsem \
    --enable-xml \
    --enable-zip \
    --enable-calendar \
    --enable-intl \
    --with-libzip \
		\
    --enable-exif=shared \
    --with-bz2=shared \
    --with-tidy=shared \
    --with-gmp=shared \
    --with-imap \
    --with-imap-ssl \
    --with-xmlrpc=shared \
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
  && ln -s ${PHP_PREFIX}/bin /usr/local/sbin \
	&& pecl update-channels \
	&& rm -rf /tmp/pear ~/.pearrc \
  && set -ex \
	&& cd ${PHP_PREFIX}/etc \
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
			echo 'include=etc/php-fpm.d/*.conf'; \
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
                           bz2 \
                           tidy \
                           exif \
                           gmp \
                           xmlrpc \
  && curl -fsSL https://raw.githubusercontent.com/khs1994-docker/lnmp/dev/wsl/php.fpm.zz-wsl.conf.example \
       > ${PHP_PREFIX}/etc/php-fpm.d/zz-wsl.conf \
  && curl -s -f -L -o /tmp/installer.php \
         https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
  && php -r " \
          \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
          \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
          if (!hash_equals(\$signature, \$hash)) { \
              unlink('/tmp/installer.php'); \
              echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
              exit(1); \
          }" \
  && php /tmp/installer.php --no-ansi --install-dir=/usr/local/php72/bin --filename=composer --version=${COMPOSER_VERSION} \
  && composer --ansi --version --no-interaction \
  && rm -rf /tmp/*

      # nginx apt

      # apache other

      # mysql apt

      # mariadb apt

      # redis

COPY --from=redis:4.0.9 /usr/local/bin/redis-* ${PHP_PREFIX}/bin/

      # memcached

COPY --from=memcached:1.5.6 /usr/local/bin/memcached ${PHP_PREFIX}/bin/

      # rabbitmq apt

      # postgresql apt

      # mongodb

      # phpmyadmin

RUN cd /usr/local ; tar -zcvf wsl-php72.tar.gz php72 ; cd etc ; tar -zcvf wsl-php72-etc.tar.gz php72

FROM hello-world:latest@sha256:97ce6fa4b6cdc0790cda65fe7290b74cfebd9fa0c9b8c38e979330d547d22ce1

# scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=0 /usr/local/wsl-php72.tar.gz /

COPY --from=0 /usr/local/etc/wsl-php72-etc.tar.gz /
