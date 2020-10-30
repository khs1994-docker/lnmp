FROM mysql:8.0.22

LABEL maintainer="khs1994-docker/lnmp <khs1994@khs1994.com>"

ARG DEB_URL=deb.debian.org

ARG DEB_SECURITY_URL=security.debian.org/debian-security

RUN sed -i "s!deb.debian.org!${DEB_URL}!g" /etc/apt/sources.list \
    && sed -i "s!security.debian.org/debian-security!${DEB_SECURITY_URL}!g" /etc/apt/sources.list \
    && echo 0
