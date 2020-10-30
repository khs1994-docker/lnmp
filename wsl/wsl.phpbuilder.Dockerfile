ARG OS_TYPE=debian:buster-slim

FROM ${OS_TYPE} as builder

ENV TZ=Asia/Shanghai

ARG LNMP_CN_ENV=false

ENV LNMP_CN_ENV=${LNMP_CN_ENV}

ARG PHP_VERSION=7.4.12

COPY lnmp-wsl-builder-php /lnmp-wsl-builder-php.sh

COPY wsl-php-ext-enable.sh /usr/local/bin/wsl-php-ext-enable.sh

RUN chmod +x /usr/local/bin/wsl-php-ext-enable.sh \
      && bash /lnmp-wsl-builder-php.sh ${PHP_VERSION} tar deb --ci

FROM scratch as tar

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

################################################################################

# FROM scratch as deb

# LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.deb /
