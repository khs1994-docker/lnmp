FROM mariadb:10.6.1

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG DEB_URL=archive.ubuntu.com

RUN sed -i "s!archive.ubuntu.com!${DEB_URL}!g" /etc/apt/sources.list \
    && sed -i "s!security.ubuntu.com!${DEB_URL}!g" /etc/apt/sources.list \
    && echo 0
