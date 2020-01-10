FROM nginx:1.17.7-alpine

LABEL maintainer="khs1994@khs1994.com" \
      version="1.17.0"

ARG CT_URL=https://github.com/coreos/container-linux-config-transpiler/releases/download/
ARG FCCT_URL=https://github.com/coreos/fcct/releases/download/
ARG CT_VERSION=v0.9.0
ARG FCCT_VERSION=v0.2.0
RUN mkdir -p /srv/www/coreos \
      && apk add --no-cache tzdata curl \
      && curl -L ${FCCT_URL}${FCCT_VERSION}/fcct-x86_64-unknown-linux-gnu > /usr/local/bin/fcct \
      && chmod +x /usr/local/bin/fcct \
      && apk del curl \
      && apk add --no-cache --virtual .gettext gettext \
      && mv /usr/bin/envsubst /tmp/ \
      && apk del .gettext \
      && mv /tmp/envsubst /usr/local/bin/

COPY nginx.conf docker-entrypoint.sh /etc/nginx/

COPY ipxe.html /srv/www/coreos/

CMD sh /etc/nginx/docker-entrypoint.sh
