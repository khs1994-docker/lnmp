FROM alpine:edge

RUN set -x ; apk add --no-cache cfssl

WORKDIR /opt

ENTRYPOINT ["cfssl"]

CMD ["--help"]

VOLUME [ "/opt" ]
