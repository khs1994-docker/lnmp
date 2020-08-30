# syntax=docker/dockerfile:experimental
FROM alpine

RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret

RUN --mount=type=secret,id=mysecret,target=/foobar cat /foobar

RUN --mount=type=cache,target=/root/.cache ls -la /root/.cache \
      && echo 1 > /root/.cache/1.txt

RUN --mount=type=tmpfs,target=/tmpfs ls -la /tmpfs

RUN --mount=type=bind,from='',source='',target='',rw
