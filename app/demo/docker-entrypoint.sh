#!/bin/sh

PHP_ROOT_PATH=/app/demo

START=`date "+%F %T"`

if [ "$1" = "sh" -o "$1" = "bash" ];then $1 ; exit 0; fi

main(){
  cd ${PHP_ROOT_PATH}
  composer install
  php-fpm -R
}

main $1 $2 $3
