#!/usr/bin/env bash

set -x

cp ../.env.example .env
cat ../lrew/httpd/.env.compose >> .env
cat ../lrew/mariadb/.env.compose >> .env

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

docker cp config_php7_1_666:/usr/local/etc php/default/usr/local/

docker cp config_php8_1_666:/usr/local/etc php8/default/usr/local/

docker cp config_nginx_1_666:/etc/nginx/nginx.conf etc/default/nginx/

docker cp config_nginx_1_666:/etc/nginx/conf.d etc/default/nginx/

docker cp config_httpd_1_666:/usr/local/apache2/conf/httpd.conf etc/default/apache2/httpd.conf

docker cp config_mariadb_1_666:/etc/mysql mariadb/default/etc/

docker cp config_mysql_1_666:/etc/mysql mysql/default/etc/

docker-compose down

rm -rf php/default/usr/local/etc/pear.conf

set +x
echo "\`\`\`bash" > path.md

tree . >> path.md

echo "\`\`\`" >> path.md
set -x
source ./.env

wget https://github.com/redis/redis/raw/${LNMP_REDIS_VERSION:-6.0.9}/redis.conf -O redis/redis.example.conf

cp redis/redis.example.conf redis/redis.production.conf

curl -L https://raw.githubusercontent.com/php/php-src/php-${LNMP_PHP_VERSION}/php.ini-production > php/php.production.ini

curl -L https://raw.githubusercontent.com/php/php-src/php-${LNMP_PHP_VERSION}/php.ini-development > php/php.development.ini

rm -rf .env

rm -rf php/default/usr/local/etc/php/php.ini-*
