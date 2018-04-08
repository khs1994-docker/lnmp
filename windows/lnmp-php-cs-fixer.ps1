#
# https://github.com/FriendsOfPHP/PHP-CS-Fixer
#

docker run -it --rm `
  --mount type=bind,src=$PWD,target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=/tmp/cache `
  --entrypoint php-cs-fixer `
  khs1994/php-fpm:7.2.4-alpine3.7 `
  $args
