FROM nginx:1.19.3-alpine

LABEL maintainer="khs1994@khs1994.com" \
      version="1.19.0"

ARG FCCT_URL=https://github.com/coreos/fcct/releases/download/
ARG FCCT_VERSION=v0.6.0

COPY --from=quay.io/coreos/fcct:v0.7.0 /usr/local/bin/fcct /usr/local/bin/fcct

RUN set -ex \
      && ARCH=`uname -m` \
      && mkdir -p /srv/www/coreos \
      && apk add --no-cache tzdata curl \
      # && curl -L ${FCCT_URL}${FCCT_VERSION}/fcct-${ARCH}-unknown-linux-gnu > /usr/local/bin/fcct \
      # && chmod +x /usr/local/bin/fcct \
      # && /usr/local/bin/fcct --version \
      && apk del --no-network curl \
      && apk add --no-cache --virtual .gettext gettext \
      && mv /usr/bin/envsubst /tmp/ \
      && apk del --no-network .gettext \
      && mv /tmp/envsubst /usr/local/bin/

COPY nginx.conf docker-entrypoint.sh /etc/nginx/

COPY ipxe.html /srv/www/coreos/

ENTRYPOINT ["sh", "/etc/nginx/docker-entrypoint.sh"]
