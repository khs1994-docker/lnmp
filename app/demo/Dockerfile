FROM khs1994/php-fpm:7.2.2-alpine3.7

COPY . /app/demo/

RUN cd /app/demo \
      && if [ -f composer.json ];then \
           echo "Compose packages installing..."; \
           composer install --no-dev; \
           echo $?; \
           echo "Composer packages install success"; \
         else \
           echo "composer.json NOT exists"; \
         fi

FROM khs1994/php-fpm:7.2.2-alpine3.7

COPY --from=0 /app /app

CMD ["php-fpm", "-R"]
