FROM alpine:3.10

ENV KUBERNETES_VERSION=v1.15.0

# ENV KUBERNETES_VERSION=v1.15.0-beta.2

ENV KUBERNETES_URL=https://storage.googleapis.com

ARG GOOS=linux
ARG GOARCH=amd64
# ARG GOARCH=arm
# ARG GOARCH=arm64
ARG TYPE=server
# ARG TYPE=client
# ARG TYPE=node

# https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/kubernetes-${TYPE}-${GOOS}-${GOARCH}.tar.gz

RUN apk add --no-cache curl \
       && cd / \
       && curl -LO ${KUBERNETES_URL}/kubernetes-release/release/${KUBERNETES_VERSION}/kubernetes-${TYPE}-${GOOS}-${GOARCH}.tar.gz \
       && ls /kubernetes*

FROM hello-world

ARG GOOS=linux
ARG GOARCH=amd64
# ARG GOARCH=arm
# ARG GOARCH=arm64
ARG TYPE=server
# ARG TYPE=client
# ARG TYPE=node

COPY --from=0 /kubernetes-${TYPE}-${GOOS}-${GOARCH}.tar.gz /
