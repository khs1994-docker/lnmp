FROM khs1994/builder:ruby

ARG VERSION=4.0.8

ARG REDIS_URL=raw.githubusercontent.com/antirez/redis

RUN wget https://${REDIS_URL}/${VERSION}/src/redis-trib.rb -O /usr/bin/redis-trib.rb \
    && chmod +x /usr/bin/redis-trib.rb \
    && gem install redis

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
