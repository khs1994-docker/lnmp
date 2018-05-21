FROM arm32v7/php:7.2.5-fpm-stretch@sha256:f4cde3011529e8af5f8c6e110609ac6796f69dc98e1e47c9818f7864053f7e2b

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories
