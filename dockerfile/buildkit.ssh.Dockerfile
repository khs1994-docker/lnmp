# syntax = tonistiigi/dockerfile:20181026-ssh
FROM alpine

RUN apk add --no-cache git openssh-client

RUN --mount=type=ssh mkdir -p -m 0700 ~/.ssh \
      && ssh-keyscan github.com >> ~/.ssh/known_hosts \
      && git clone git@github.com:khs1994-docker/lnmp
