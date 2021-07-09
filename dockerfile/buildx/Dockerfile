# syntax=docker/dockerfile-upstream:master-labs
FROM alpine

RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret

RUN --mount=type=secret,id=mysecret,target=/foobar cat /foobar

RUN --mount=type=cache,target=/root/.cache ls -la /root/.cache \
      && echo 1 > /root/.cache/1.txt

RUN --mount=type=tmpfs,target=/tmpfs ls -la /tmpfs

RUN --mount=type=bind,from='',source='',target='',rw

# RUN --security=insecure|sandbox
RUN --security=insecure cat /proc/self/status | grep CapEff

# RUN --network=none|host|default
RUN --network=none pip install --find-links wheels mypackage
