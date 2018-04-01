ARG OS_TYPE=centos:7.4.1708

FROM ${OS_TYPE}

ARG PHP_VERSION=5.6.35

COPY lnmp-wsl-php-builder-rhel.sh /lnmp-wsl-php-builder-rhel.sh

RUN sed -i "s#sudo##g" /lnmp-wsl-php-builder-rhel.sh \
      && sh /lnmp-wsl-php-builder-rhel.sh ${PHP_VERSION} tar

FROM hello-world

# scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=0 /*.tar.gz /
