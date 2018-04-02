ARG OS_TYPE=debian:stretch-slim

FROM ${OS_TYPE} as builder

ARG PHP_VERSION=7.2.4

COPY lnmp-wsl-php-builder.sh /lnmp-wsl-php-builder.sh

RUN sed -i "s#sudo##g" /lnmp-wsl-php-builder.sh \
      && sh /lnmp-wsl-php-builder.sh ${PHP_VERSION} tar deb

FROM hello-world:latest@sha256:97ce6fa4b6cdc0790cda65fe7290b74cfebd9fa0c9b8c38e979330d547d22ce1 as tar

# scratch

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /*.tar.gz /

FROM hello-world:latest@sha256:97ce6fa4b6cdc0790cda65fe7290b74cfebd9fa0c9b8c38e979330d547d22ce1 as deb

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

COPY --from=builder /tmp/*.deb /
