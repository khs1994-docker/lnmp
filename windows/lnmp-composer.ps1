docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache khs1994/php-fpm:7.2.2-alpine3.7 composer "$args"
