FROM alpine:3.12

ENV KUBECTL_VERSION=v1.18.0

RUN apk add --no-cache curl \
      && curl -L https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64 > /usr/local/bin/cfssl \
      && curl -L https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_amd64 > /usr/local/bin/cfssljson \
      && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
      && chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/kubectl \
      && apk del --no-network curl

FROM alpine:3.12

LABEL maintainer="khs1994@khs1994.com" \
      version="1.18.0"

COPY --from=0 /usr/local/bin /usr/local/bin

RUN apk add --no-cache bash openssl

WORKDIR /srv/cfssl

VOLUME /srv/cfssl

COPY *.yaml /

COPY docker-entrypoint.sh /

CMD bash /docker-entrypoint.sh
