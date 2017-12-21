FROM memcached:1.5.4-alpine

ENV TZ=Asia/Shanghai

USER root

# cn

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache tzdata

USER memcache
