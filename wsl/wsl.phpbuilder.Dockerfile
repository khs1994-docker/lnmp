ARG OS_TYPE=debian:buster-slim

FROM ${OS_TYPE} as builder

ENV TZ Asia/Shanghai

ARG PHP_VERSION=7.3.10

COPY lnmp-wsl-builder-php /lnmp-wsl-builder-php.sh

COPY wsl-php-ext-enable.sh /usr/local/bin/wsl-php-ext-enable.sh

RUN chmod +x /usr/local/bin/wsl-php-ext-enable.sh \
      && sh /lnmp-wsl-builder-php.sh ${PHP_VERSION} tar deb travis

FROM scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

################################################################################

# FROM scratch as deb
#
# LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.deb /
