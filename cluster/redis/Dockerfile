FROM khs1994/builder:ruby@sha256:d8cd3d80bb100b7bd747a1d1b42f20db0d4e00a507e15b39d82bb3aa3e7bb742

ARG VERSION=4.0.9

ARG REDIS_URL=raw.githubusercontent.com/antirez/redis

RUN wget https://${REDIS_URL}/${VERSION}/src/redis-trib.rb -O /usr/bin/redis-trib.rb \
    && chmod +x /usr/bin/redis-trib.rb \
    && gem install redis

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
