FROM khs1994/builder:ruby

RUN apk add --no-cache \
            ruby-dev \
            gcc g++ make \
            git \
    && gem install travis \
    && apk del --no-cache gcc g++ make ruby-dev

COPY docker-entrypoint.sh /

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
