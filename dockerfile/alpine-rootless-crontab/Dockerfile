FROM alpine

RUN set -x ; \
    sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk add --update --no-cache libcap \
    && setcap cap_setgid=ep /bin/busybox
