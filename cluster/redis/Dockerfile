FROM alpine:latest

ARG VERSION=4.0.8

ARG REDIS_URL=raw.githubusercontent.com/antirez/redis

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    && wget https://${REDIS_URL}/${VERSION}/src/redis-trib.rb -O /usr/bin/redis-trib.rb \
    && chmod +x /usr/bin/redis-trib.rb \
    && apk add --no-cache \
            ruby \
            ruby-rdoc \
            ruby-irb \
    && gem install redis

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
