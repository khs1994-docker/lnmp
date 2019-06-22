FROM alpine:3.10

ENV KUBECTL_VERSION=v1.15.0

RUN apk add --no-cache curl \
      && curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/local/bin/cfssl \
      # && curl -s -L -o /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 \
      && curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/local/bin/cfssljson \
      && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
      && chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/kubectl \
      && apk del curl

FROM alpine:3.10

LABEL maintainer="khs1994@khs1994.com" \
      version="1.15.0"

COPY --from=0 /usr/local/bin /usr/local/bin

RUN apk add --no-cache bash

WORKDIR /srv/cfssl

VOLUME /srv/cfssl

COPY *.yaml /

COPY docker-entrypoint.sh /

CMD bash /docker-entrypoint.sh
