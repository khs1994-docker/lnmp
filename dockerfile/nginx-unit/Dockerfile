ARG PHP_VERSION=nightly

FROM khs1994/php:${PHP_VERSION}-fpm-alpine

ARG NGINX_UNIT_VERSION=1.3

RUN git clone --depth=1 -b ${NGINX_UNIT_VERSION} https://github.com/nginx/unit /usr/src/unit \
      && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
      && cd /usr/local/lib \
      && tar -zxvf libphp7.so.tar.gz \
      && rm -rf *.tar.gz \
      && cd /usr/src/unit \
      && ./configure --prefix=/usr/local/nginx-unit \
      && ./configure php \
      --module=php73 \
      --lib-path=/usr/local/lib \
      --config=/usr/local/bin/php-config \
      && make \
      && make install \
      && ln -sf /usr/local/nginx-unit/sbin/unitd /usr/local/sbin \
      && apk del --no-cache .build-deps \
      && rm -rf /usr/src/unit \
      && mkdir -p /var/log/nginx-unit \
      && ln -sf /dev/stdout /var/log/nginx-unit/nginx-unit.log

CMD ["unitd","--no-daemon","--user","root","--group","root","--log","/var/log/nginx-unit/nginx-unit.log"]
