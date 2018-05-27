FROM arm32v7/php:7.2.6-fpm-stretch@sha256:c481aee0899e021a1f0b2904addc52588353d247261522ad2bb6d46b8ea0488a

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories
