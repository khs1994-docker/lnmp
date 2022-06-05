FROM --platform=${TARGETPLATFORM} alpine:edge as tool

ENV KUBECTL_VERSION=v1.24.0

ARG TARGETARCH

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN set -x \
    ; echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    ; sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    ; apk add --no-cache curl \
    ; apk add --no-cache cfssl \
    ; cp -a /usr/bin/cfssl /usr/bin/cfssljson /usr/local/bin \
    ; curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl > /usr/local/bin/kubectl \
    && apk del --no-network curl \
    && chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/kubectl

FROM --platform=${TARGETPLATFORM} alpine:3.16 as dump

LABEL maintainer="khs1994@khs1994.com" \
      version="1.24.0"

COPY --from=0 /usr/local/bin /usr/local/bin

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN set -x \
    ; sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    ; apk add --no-cache bash openssl

WORKDIR /srv/cfssl

VOLUME /srv/cfssl

COPY *.yaml /

COPY docker-entrypoint.sh /

CMD bash /docker-entrypoint.sh

FROM scratch as all-in-one

COPY --from=1 / /
