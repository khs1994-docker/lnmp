FROM khs1994/php-fpm:7.2.0-alpine3.7

WORKDIR /

RUN rm -rf /app \
      && git clone -b php-fpm https://github.com/khs1994-docker/swarm-lnmp-demo.git /app \
      && cd /app/demo \
      && if [ -f composer.json ];then echo "Compose packages installing..."; composer install ; echo "Composer packages install success"; \
      else echo "composer.json NOT exists"; fi \
      # 删除 .git
      && rm -rf /app/.git

FROM  khs1994/php-fpm:7.2.0-alpine3.7

COPY --from=0 /app /app
