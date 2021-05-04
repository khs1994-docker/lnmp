FROM --platform=${TARGETPLATFORM} alpine:edge

ENV KUBECTL_VERSION=v1.21.0

ARG TARGETARCH

RUN set -x \
    ; echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    ; apk add --no-cache curl ; \
    if [ "${TARGETARCH}" = 'amd64' ];then \
      curl -L https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_${TARGETARCH} > /usr/local/bin/cfssl \
      && curl -L https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_${TARGETARCH} > /usr/local/bin/cfssljson; \
    else \
      apk add --no-cache cfssl \
      && cp -a /usr/bin/cfssl /usr/bin/cfssljson /usr/local/bin; \
    fi \
    \
    ; curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl > /usr/local/bin/kubectl \
    && apk del --no-network curl \
    && chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/kubectl

FROM --platform=${TARGETPLATFORM} alpine:3.13

LABEL maintainer="khs1994@khs1994.com" \
      version="1.21.0"

COPY --from=0 /usr/local/bin /usr/local/bin

RUN set -x ; apk add --no-cache bash openssl

WORKDIR /srv/cfssl

VOLUME /srv/cfssl

COPY *.yaml /

COPY docker-entrypoint.sh /

CMD bash /docker-entrypoint.sh
