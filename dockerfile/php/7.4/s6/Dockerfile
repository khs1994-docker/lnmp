# syntax=docker/dockerfile:experimental

ARG PHP_VERSION=7.4.12
ARG USERNAME=khs1994
ARG BASE=fpm

FROM --platform=$TARGETPLATFORM ${USERNAME}/php:${PHP_VERSION}-${BASE}-alpine

RUN --mount=type=bind,from=khs1994/s6:2.1.0.2,source=/,target=/tmp/s6 \
    set -x \
    && tar -zxvf /tmp/s6/s6-overlay.tar.gz -C / \
# https://github.com/MinchinWeb/docker-base/commit/f5e350dcf3523a424772a1e42a3dba3200d7a2aa
    && ln -s /init /s6-init

VOLUME [ "/etc/services.d"]

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

# ENTRYPOINT ["/s6-init"]

ENTRYPOINT ["s6-svscan", "-t0", "/etc/services.d"]

ARG VCS_REF="unknow"

LABEL org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/khs1994-docker/php"
