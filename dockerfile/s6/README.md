# s6

## 示例

```docker
# syntax=docker/dockerfile:labs

FROM --platform=$TARGETPLATFORM alpine

RUN --mount=type=bind,from=khs1994/s6:3.1.0.1,source=/,target=/tmp/s6 \
    set -x \
#   && apt-get update && apt-get install -y xz-utils
    && tar -xvf /tmp/s6/s6-overlay-noarch.tar.xz -C /
    && tar -xvf /tmp/s6/s6-overlay.tar.xz -C /

ENTRYPOINT ["/s6-init"]
```
