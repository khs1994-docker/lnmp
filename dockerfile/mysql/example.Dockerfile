FROM mysql:8.0.3

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG DEB_URL=deb.debian.org

ARG DEB_SECURITY_URL=security.debian.org

RUN sed -i "s!deb.debian.org!${DEB_URL}!g" /etc/apt/sources.list \
    && sed -i "s!security.debian.org!${DEB_SECURITY_URL}!g" /etc/apt/sources.list \
    && echo 0
