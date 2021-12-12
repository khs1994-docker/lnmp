FROM nginx:1.21.3-alpine

LABEL maintainer="khs1994@khs1994.com"

ARG BUTANE_URL=https://github.com/coreos/butane/releases/download/
ARG BUTANE_VERSION=v0.13.1

COPY --from=quay.io/coreos/butane:v0.13.1 /usr/local/bin/butane /usr/local/bin/butane

RUN set -ex \
      && ARCH=`uname -m` \
      && mkdir -p /srv/www/coreos \
      && apk add --no-cache tzdata curl \
      # && curl -L ${BUTANE_URL}${BUTANE_VERSION}/butane-${ARCH}-unknown-linux-gnu > /usr/local/bin/butane \
      # && chmod +x /usr/local/bin/butane \
      # && /usr/local/bin/butane --version \
      && apk del --no-network curl \
      && apk add --no-cache --virtual .gettext gettext \
      && mv /usr/bin/envsubst /tmp/ \
      && apk del --no-network .gettext \
      && mv /tmp/envsubst /usr/local/bin/

COPY nginx.conf docker-entrypoint.sh /etc/nginx/

COPY ipxe.html /srv/www/coreos/

ENTRYPOINT ["sh", "/etc/nginx/docker-entrypoint.sh"]
