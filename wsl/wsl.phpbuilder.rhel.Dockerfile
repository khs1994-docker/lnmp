ARG OS_TYPE=centos:7.6.1810

FROM ${OS_TYPE} as builder

ENV TZ Asia/Shanghai

ARG PHP_VERSION=7.3.9

COPY lnmp-wsl-builder-php-rhel /lnmp-wsl-builder-php-rhel.sh

COPY wsl-php-ext-enable.sh /usr/local/bin/wsl-php-ext-enable.sh

RUN chmod +x /usr/local/bin/wsl-php-ext-enable.sh \
      && sh /lnmp-wsl-builder-php-rhel.sh ${PHP_VERSION} tar rpm travis

FROM scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

################################################################################

# FROM scratch as rpm
#
# LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.rpm /
