# syntax=ghcr.io/khs1994-docker/docker.io/docker/dockerfile-upstream:master-labs
FROM alpine

RUN apk add --no-cache git openssh-client

RUN --mount=type=ssh mkdir -p -m 0700 ~/.ssh \
      && ssh-keyscan github.com >> ~/.ssh/known_hosts \
      && git clone git@github.com:khs1994-docker/lnmp
