FROM ghcr.io/khs1994-docker/docker.io/library/alpine:3.22

RUN apk add --no-cache openssl

COPY *.cnf root-ca.crt root-ca.key /srv/

WORKDIR /ssl

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
