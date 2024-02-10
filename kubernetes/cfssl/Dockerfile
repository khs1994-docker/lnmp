FROM --platform=${TARGETPLATFORM} alpine:edge as tool

ENV KUBECTL_VERSION=v1.29.0

ARG TARGETARCH

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN set -x \
    ; echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    ; sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_URL}/g" /etc/apk/repositories \
    ; apk add --no-cache curl \
    ; apk add --no-cache cfssl \
    ; apk add --no-cache bash \
    ; apk add --no-cache openssl \
    ; curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl > /usr/local/bin/kubectl \
    && apk del --no-network curl \
    && chmod +x /usr/local/bin/kubectl

WORKDIR /srv/cfssl

VOLUME /srv/cfssl

COPY *.yaml /

COPY docker-entrypoint.sh /

CMD bash /docker-entrypoint.sh
