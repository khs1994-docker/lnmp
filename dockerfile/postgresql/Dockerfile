FROM postgres:10.1-alpine

ENV TZ=Asia/Shanghai

# cn

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache tzdata
