FROM alpine:3.7@sha256:7df6db5aa61ae9480f52f0b3a06a140ab98d427f86d8d5de0bedab9b8df6b1c0

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ENV ACME_SH_VERSION=2.7.7 \
    AUTO_UPGRADE=1 \
    LE_CONFIG_HOME=/acme.sh

RUN apk add --no-cache openssl \
                       curl \
                       socat \
    && curl https://raw.githubusercontent.com/Neilpang/acme.sh/${ACME_SH_VERSION}/acme.sh | INSTALLONLINE=1  sh \
    && ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /acme.sh /ssl

ENTRYPOINT ["/docker-entrypoint.sh"]
