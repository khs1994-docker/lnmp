ARG OS_TYPE=centos:7.4.1708

FROM ${OS_TYPE} as builder

ENV TZ Asia/Shanghai

ARG PHP_VERSION=7.2.13

COPY lnmp-wsl-builder-php-rhel /lnmp-wsl-builder-php-rhel.sh

COPY wsl-php-ext-enable.sh /usr/local/bin/wsl-php-ext-enable.sh

RUN sed -i "s#sudo##g" /lnmp-wsl-builder-php-rhel.sh \
      && chmod +x /usr/local/bin/wsl-php-ext-enable.sh \
      && sh /lnmp-wsl-builder-php-rhel.sh ${PHP_VERSION} tar rpm travis

# scratch

FROM hello-world:latest

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

################################################################################

# FROM hello-world:latest as rpm
#
# LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.rpm /
