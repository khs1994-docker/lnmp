FROM khs1994/nginx:1.13.7-alpine

RUN apk add --no-cache git \
      && git clone https://github.com/khs1994-docker/swarm-lnmp-php-demo.git /app \
      && rm -rf /etc/nginx/conf.d \
      && git clone https://github.com/khs1994-docker/swarm-lnmp-nginx-config-demo.git /etc/nginx/conf.d \
      && apk del git
