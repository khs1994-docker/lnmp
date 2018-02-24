if (! (Test-Path vendor\bin\phpunit)){
  echo "
PHPUnit not found, You Must EXEC

$ lnmp-composer require phpunit

OR

$ lnmp-composer install
"

exit 1

}

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache khs1994/php-fpm:7.2.2-alpine3.7 vendor/bin/phpunit $args
