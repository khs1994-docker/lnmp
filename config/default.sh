#!/bin/bash

cp ../.env.example .env

echo COMPOSE_PROJECT_NAME=config >> .env

docker-compose up -d

rm -rf php/default \
       etc/default \
       mariadb/default \
       mysql/default

mkdir -p php/default/usr/local \
         etc/default/nginx \
         etc/default/apache2 \
         mariadb/default/etc \
         mysql/default/etc

docker cp config_php7_1:/usr/local/etc php/default/usr/local/

docker cp config_nginx_1:/etc/nginx/nginx.conf etc/default/nginx/

docker cp config_nginx_1:/etc/nginx/conf.d etc/default/nginx/

docker cp config_httpd_1:/usr/local/apache2/conf/httpd.conf etc/default/apache2/httpd.conf

docker cp config_mariadb_1:/etc/mysql mariadb/default/etc/

docker cp config_mysql_1:/etc/mysql mysql/default/etc/

docker-compose down

rm -rf php/default/usr/local/etc/pear.conf

echo "\`\`\`bash" > path.md

tree . >> path.md

echo "\`\`\`" >> path.md

. .env

wget https://gitee.com/mirrors/redis/raw/${KHS1994_LNMP_REDIS_VERSION}/redis.conf -O redis/redis.conf

cp redis/redis.conf redis/redis.production.conf

curl -L https://raw.githubusercontent.com/php/php-src/php-${KHS1994_LNMP_PHP_VERSION}/php.ini-production > php/php.production.ini

curl -L https://raw.githubusercontent.com/php/php-src/php-${KHS1994_LNMP_PHP_VERSION}/php.ini-development > php/php.development.ini

rm -rf .env
