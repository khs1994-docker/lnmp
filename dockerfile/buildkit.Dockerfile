# syntax = tonistiigi/dockerfile:20181026-secrets
FROM alpine

RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret > /test.txt

RUN --mount=type=secret,id=mysecret,dst=/foobar cat /foobar > /test2.txt

RUN apk add --no-cache git openssh-client

RUN --mount=type=ssh git clone git@github.com:khs1994-docker/lnmp
