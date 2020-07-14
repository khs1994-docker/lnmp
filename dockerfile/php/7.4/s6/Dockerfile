ARG PHP_VERSION=7.4.8
ARG USERNAME=khs1994

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-fpm-alpine

ARG S6_VERSION=2.0.0.1

ARG TARGETARCH

RUN set -x \
    && if [ "${TARGETARCH}" = 'arm64' ];then TARGETARCH=aarch64; fi \
    && if [ "${TARGETARCH}" = 'arm32' ];then TARGETARCH=arm; fi \
    && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${TARGETARCH}.tar.gz -o /tmp/s6-overlay.tar.gz \
    && tar -zxvf /tmp/s6-overlay.tar.gz -C / \
#    && tar -zxvf /tmp/s6-overlay.tar.gz -C / --exclude='./bin' \
#    && tar -zxvf /tmp/s6-overlay.tar.gz -C /usr ./bin \
    && rm -rf /tmp/s6-overlay.tar.gz \
# https://github.com/MinchinWeb/docker-base/commit/f5e350dcf3523a424772a1e42a3dba3200d7a2aa
    && ln -s /init /s6-init

VOLUME [ "/etc/services.d", "/etc/fix-attrs.d", "/etc/cont-init.d", "cont-finish.d" ]

ENV S6_KEEP_ENV=0 \
    S6_LOGGING=0 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=0 \
    S6_KILL_FINISH_MAXTIME=5000 \
    S6_SERVICES_GRACETIME=3000 \
    S6_KILL_GRACETIME=3000 \
    S6_LOGGING_SCRIPT="n20 s1000000 T" \
    S6_CMD_ARG0= \
    S6_FIX_ATTRS_HIDDEN=0 \
    S6_CMD_WAIT_FOR_SERVICES=0  \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=5000 \
    S6_READ_ONLY_ROOT=0 \
    S6_SYNC_DISKS=0

ENTRYPOINT ["/s6-init"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
