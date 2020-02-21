# syntax=docker/dockerfile:experimental
ARG PHP_VERSION=7.3.15

FROM --platform=$TARGETPLATFORM khs1994/php:${PHP_VERSION}-cli-alpine

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/khs1994-docker/php"

ENV NGINX_UNIT_VERSION 1.15.0

RUN cd /usr/src \
  && curl -fsSL https://github.com/nginx/unit/archive/${NGINX_UNIT_VERSION}.tar.gz \
     | tar -zxvf - \
  && mv unit-${NGINX_UNIT_VERSION} unit \
  && cd /usr/src/unit \
  && apk add --no-cache --virtual .build-deps \
                                  $PHPIZE_DEPS \
                                  openssl-dev \
                                  linux-headers \
  && ./configure --prefix=/usr/local/nginx-unit --openssl \
  && ./configure php \
       --module=php73 \
       --lib-path=/usr/local/lib \
       --config=/usr/local/bin/php-config \
  && make -j "$(nproc)" \
  && make install \
  && strip --strip-all /usr/local/nginx-unit/sbin/unitd \
  && mkdir -p /usr/local/sbin \
  && ln -sf /usr/local/nginx-unit/sbin/unitd /usr/local/sbin/unitd \
  && apk del --no-network --no-cache .build-deps \
  && rm -rf /usr/src/* \
  && mkdir -p /var/log/nginx-unit \
  && ln -sf /dev/stdout /var/log/nginx-unit/nginx-unit.log

ENV PS1="[\u@\h \w]# "

ENTRYPOINT ["unitd"]

CMD ["--no-daemon","--user","root","--group","root","--log","/var/log/nginx-unit/nginx-unit.log"]

WORKDIR /app
