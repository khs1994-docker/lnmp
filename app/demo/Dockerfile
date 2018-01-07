FROM php:7.2.1-fpm-alpine3.7

COPY . /app/demo/

RUN cd /app/demo \
      && if [ -f composer.json ];then \
           echo "Compose packages installing..."; \
           composer install; \
           echo $?; \
           echo "Composer packages install success"; \
         else \
           echo "composer.json NOT exists"; \
         fi

FROM php:7.2.1-fpm-alpine3.7

COPY --from=0 /app /app

CMD ["php-fpm", "-R"]
