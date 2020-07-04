ARG PHP_VERSION=7.4.7
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine

ARG S6_VERSION=2.0.0.1

ARG TARGETARCH

RUN set -x \
    && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${TARGETARCH}.tar.gz -o /tmp/s6-overlay.tar.gz \
    && tar -zxvf /tmp/s6-overlay.tar.gz -C / \
    && rm -rf /tmp/s6-overlay.tar.gz

ENTRYPOINT ["/bin/s6-svscan"]

CMD ["/usr/local/etc/s6"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
