FROM alpine as downloader

ARG S6_VERSION=3.1.0.1

ARG TARGETARCH

RUN set -x \
    && if [ "${TARGETARCH}" = 'arm64' ];then TARGETARCH=aarch64; fi \
    && if [ "${TARGETARCH}" = 'arm32' ];then TARGETARCH=arm; fi \
    && if [ "${TARGETARCH}" = 'amd64' ];then TARGETARCH=x86_64; fi \
    && apk add --no-cache curl \
    && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz -o /s6-overlay-noarch.tar.xz \
    && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${TARGETARCH}.tar.xz -o /s6-overlay.tar.xz

FROM scratch

COPY --from=downloader /s6-overlay-noarch.tar.xz /

COPY --from=downloader /s6-overlay.tar.xz /
