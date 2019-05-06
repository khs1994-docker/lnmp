FROM alpine:3.9

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ENV ACME_SH_VERSION=2.8.1 \
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
