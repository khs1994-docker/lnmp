FROM khs1994/builder:ruby@sha256:d8cd3d80bb100b7bd747a1d1b42f20db0d4e00a507e15b39d82bb3aa3e7bb742

RUN apk add --no-cache \
            ruby-dev \
            gcc g++ make \
            git \
    && gem install travis \
    && apk del gcc g++ make ruby-dev

COPY docker-entrypoint.sh /

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
