# syntax = tonistiigi/dockerfile:secrets20180808
FROM busybox

# daemon.json {"experimental":true, "features": {"feature-buildkit":true}}

# $ docker build --no-cache --secret id=mysecret,src=$(pwd)/mysecret.txt -f buildkit.Dockerfile .

RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret > /test.txt

RUN --mount=type=secret,id=mysecret,dst=/foobar cat /foobar > /test2.txt
