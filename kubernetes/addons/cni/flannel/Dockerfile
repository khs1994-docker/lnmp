# syntax=docker/dockerfile:experimental

ARG FLANNEL_VERSION=v0.11.0

FROM quay.io/coreos/flannel:${FLANNEL_VERSION}-${TARGETARCH}

# $ docker buildx build --platform=linux/arm,linux/arm64,linux/amd64,linux/ppc64le,linux/s390x --push -t dockerpracticesig/flanneld:v0.11.0 .
# https://github.com/coreos/flannel/blob/master/Documentation/kube-flannel.yml
