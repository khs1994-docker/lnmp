FROM alpine:3.11

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN set -x \
    && sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    && apk add --no-cache \
            ruby \
            ruby-rdoc \
            ruby-irb

RUN apk add --no-cache \
            ruby-dev \
            gcc g++ make \
            git \
    && gem install travis \
    && apk del --no-network gcc g++ make ruby-dev

COPY docker-entrypoint.sh /

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
