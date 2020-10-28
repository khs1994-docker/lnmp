# s6

## 示例

**alpine/debian**

```docker
# syntax=docker/dockerfile:experimental

FROM --platform=$TARGETPLATFORM alpine

RUN --mount=type=bind,from=khs1994/s6:2.1.0.2,source=/,target=/tmp/s6 \
    set -x \
    && tar -zxvf /tmp/s6/s6-overlay.tar.gz -C / \
# https://github.com/MinchinWeb/docker-base/commit/f5e350dcf3523a424772a1e42a3dba3200d7a2aa
    && ln -s /init /s6-init

ENTRYPOINT ["/s6-init"]
```

对于 `/bin` 是一个软链接( [usrmerge](https://wiki.debian.org/UsrMerge) )的系统，则按照如下方法使用。

```bash
$ ls -la /
lrwxrwxrwx   1 root root    7 Jul 29 01:29 bin -> usr/bin
```

**ubuntu/centos/fedora**

```docker
# syntax=docker/dockerfile:experimental

FROM --platform=$TARGETPLATFORM ubuntu

RUN --mount=type=bind,from=khs1994/s6:2.1.0.2,source=/,target=/tmp/s6 \
    set -x \
    && tar -zxvf /tmp/s6/s6-overlay.tar.gz -C / --exclude='./bin' \
    && tar -zxvf /tmp/s6/s6-overlay.tar.gz -C /usr ./bin \
# https://github.com/MinchinWeb/docker-base/commit/f5e350dcf3523a424772a1e42a3dba3200d7a2aa
    && ln -s /init /s6-init

ENTRYPOINT ["/s6-init"]
```
