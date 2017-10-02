FROM nginx:1.13.5-alpine

# cn

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache tzdata

# RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# http://wiki.alpinelinux.org/wiki/Setting_the_timezone
