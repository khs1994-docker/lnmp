if ($args.Count -eq 0){
  $COMMAND="-h"
} else {
  $COMMAND=$args
}

# -S 参数需要容器暴露端口

function S_ERROR(){
  Write-Host "lnmp-php [options] -S <addr>:<port> [-t docroot] [router]"
  exit 1
}

if ($args -contains '-S' ){

  if ($args.Count -lt 2){
    S_ERROR
  }

  if (!($args[1] -like '*:[2-9]*')){
    S_ERROR
  }

  $PORT=$args[1].Split(":")[-1]

  $first, $other = $args

  $first, $other = $other

  $ADDR_PORT=$args[1]

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache -p "${ADDR_PORT}:${PORT}" --network lnmp_backend khs1994/php-fpm:7.2.3-alpine3.7 php -S 0.0.0.0:$PORT $other
exit 0
}

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache khs1994/php-fpm:7.2.3-alpine3.7 php $COMMAND
