FROM alpine as downloader

ARG S6_VERSION=2.1.0.2

ARG TARGETARCH

RUN set -x \
    && if [ "${TARGETARCH}" = 'arm64' ];then TARGETARCH=aarch64; fi \
    && if [ "${TARGETARCH}" = 'arm32' ];then TARGETARCH=arm; fi \
    && apk add --no-cache curl \
    && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${TARGETARCH}.tar.gz -o /s6-overlay.tar.gz

FROM scratch

COPY --from=downloader /s6-overlay.tar.gz /
