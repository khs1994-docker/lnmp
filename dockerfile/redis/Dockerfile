FROM redis:4.0.7-alpine

ENV TZ=Asia/Shanghai

# cn

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache tzdata \
      && mkdir -p /var/log/redis \
      && touch /var/log/redis/redis.log \
      && chmod -R 777 /var/log/

COPY redis.conf /redis.conf

# RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# http://wiki.alpinelinux.org/wiki/Setting_the_timezone
