FROM alpine

RUN apk add --no-cache openssl \
                       curl \
                       socat \
    && wget -O -  https://get.acme.sh | sh

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /ssl

WORKDIR /ssl

ENTRYPOINT ["/docker-entrypoint.sh"]
