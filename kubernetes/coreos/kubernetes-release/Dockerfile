FROM alpine:3.8

ENV KUBERNETES_VERSION=v1.13.0

ENV KUBERNETES_URL=https://storage.googleapis.com

# https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz

RUN apk add --no-cache curl \
       && cd /srv \
       && curl -LO ${KUBERNETES_URL}/kubernetes-release/release/${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz \
       && cd / \
       && tar -zcvf srv.tar.gz /srv \
       && rm -rf /srv/* \
       && apk del curl

FROM hello-world

COPY --from=0 /srv.tar.gz /
