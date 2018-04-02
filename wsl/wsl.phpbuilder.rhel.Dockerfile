ARG OS_TYPE=centos:7.4.1708

FROM ${OS_TYPE} as builder

ARG PHP_VERSION=7.2.4

COPY lnmp-wsl-php-builder-rhel.sh /lnmp-wsl-php-builder-rhel.sh

RUN sed -i "s#sudo##g" /lnmp-wsl-php-builder-rhel.sh \
      && sh /lnmp-wsl-php-builder-rhel.sh ${PHP_VERSION} tar rpm

# scratch

FROM hello-world:latest@sha256:97ce6fa4b6cdc0790cda65fe7290b74cfebd9fa0c9b8c38e979330d547d22ce1 as tar

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

################################################################################

FROM hello-world:latest@sha256:97ce6fa4b6cdc0790cda65fe7290b74cfebd9fa0c9b8c38e979330d547d22ce1 as rpm

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.rpm /
