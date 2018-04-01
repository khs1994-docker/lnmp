ARG OS_TYPE=debian:stretch-slim

FROM ${OS_TYPE}

ARG PHP_VERSION=5.6.35

COPY lnmp-wsl-php-builder.sh /lnmp-wsl-php-builder.sh

RUN sed -i "s#sudo##g" /lnmp-wsl-php-builder.sh \
      && sh /lnmp-wsl-php-builder.sh ${PHP_VERSION} tar

FROM hello-world

# scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=0 /*.tar.gz /
