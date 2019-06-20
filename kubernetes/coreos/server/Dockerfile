FROM nginx:1.17.0-alpine

LABEL maintainer="khs1994@khs1994.com" \
      version="1.15.0"

ARG CT_URL=https://github.com/coreos/container-linux-config-transpiler/releases/download/

ARG CT_VERSION=v0.9.0

RUN mkdir -p /srv/www/coreos \
      && apk add --no-cache tzdata curl \
      && curl -L ${CT_URL}${CT_VERSION}/ct-${CT_VERSION}-x86_64-unknown-linux-gnu > /usr/local/bin/ct \
      && chmod +x /usr/local/bin/ct \
      && apk del curl \
      && apk add --no-cache --virtual .gettext gettext \
      && mv /usr/bin/envsubst /tmp/ \
      && apk del .gettext \
      && mv /tmp/envsubst /usr/local/bin/

COPY nginx.conf docker-entrypoint.sh /etc/nginx/

COPY ipxe.html /srv/www/coreos/

CMD sh /etc/nginx/docker-entrypoint.sh
