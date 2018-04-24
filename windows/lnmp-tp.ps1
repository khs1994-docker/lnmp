if ($args.count -lt 1){
  exit 1
}

docker run -it --rm `
  --mount type=bind,src=$PWD,target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=/tmp/cache `
  --entrypoint /docker-entrypoint.composer.sh `
  khs1994/php-fpm:7.2.4-alpine3.7 `
  composer create-project topthink/think=5.0.* $args[0] --prefer-dist
