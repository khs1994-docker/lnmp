FROM alpine

ENV ACME_SH_VERSION=2.7.5

RUN apk add --no-cache openssl \
                       curl \
                       socat \
    && curl https://raw.githubusercontent.com/Neilpang/acme.sh/${ACME_SH_VERSION}/acme.sh | INSTALLONLINE=1  sh

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /ssl

ENTRYPOINT ["/docker-entrypoint.sh"]
