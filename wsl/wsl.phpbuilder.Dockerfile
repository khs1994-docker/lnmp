ARG OS_TYPE=debian:buster-slim

FROM ${OS_TYPE} as builder

ENV TZ=Asia/Shanghai

ARG LNMP_CN_ENV=false

ENV LNMP_CN_ENV=${LNMP_CN_ENV}

ARG PHP_VERSION=8.2.2

COPY lnmp-wsl-builder-php /lnmp-wsl-builder-php.sh

COPY wsl-php-ext-enable.sh /usr/local/bin/wsl-php-ext-enable.sh

ARG DEB_URL=deb.debian.org
ARG DEB_SECURITY_URL=security.debian.org/debian-security

ARG UBUNTU_URL=archive.ubuntu.com
ARG UBUNTU_SECURITY_URL=security.ubuntu.com

RUN sed -i "s/deb.debian.org/${DEB_URL}/g" /etc/apt/sources.list \
    && sed -i "s/archive.ubuntu.com/${UBUNTU_URL}/g" /etc/apt/sources.list \
    && sed -i "s/security.ubuntu.com/${UBUNTU_SECURITY_URL}/g" /etc/apt/sources.list \
    && chmod +x /usr/local/bin/wsl-php-ext-enable.sh \
    && bash /lnmp-wsl-builder-php.sh ${PHP_VERSION} tar deb --ci

FROM scratch as tar

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

################################################################################

# FROM scratch as deb

# LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.deb /
