if ($args.Count -eq 0){
  COMMAND="-h"
} else {
  COMMAND="$args"
}

# -S 参数需要容器暴露端口

function S_ERROR(){
  Write-Host "lnmp-php [options] -S <addr>:<port> [-t docroot] [router]"
  exit 1
}

if ("$args[0]" = '-S' ){

  if [ -z "$2" ];then S_ERROR; fi

  echo "$2" | grep : > /dev/null 2>&1

  if ! [ "$?" = '0' ];then S_ERROR; fi

  ADDR=`echo "$2" | cut -d : -f 1`
  PORT=`echo "$2" | cut -d : -f 2`

  if [ -z "$PORT" ];then S_ERROR; fi

  shift 2

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache -p $ADDR:$PORT:$PORT khs1994/php-fpm:7.2.2-alpine3.7 php -S 0.0.0.0:$PORT "$@"
}

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache khs1994/php-fpm:7.2.2-alpine3.7 php $COMMAND
