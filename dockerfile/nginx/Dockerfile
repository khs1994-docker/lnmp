FROM nginx:1.13.7-alpine

ENV TZ=Asia/Shanghai

# cn

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache tzdata

COPY nginx.conf /etc/nginx/nginx.conf

# COPY ./conf.d /etc/nginx/conf.d

# RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# http://wiki.alpinelinux.org/wiki/Setting_the_timezone
