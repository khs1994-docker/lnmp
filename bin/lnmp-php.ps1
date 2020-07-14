. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

if ($args.Count -eq 0){
  $COMMAND="-h"
} else {
  $COMMAND=$args
}

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
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

docker run --init -it --rm `
   --mount type=bind,src=$(wslpath $PWD),target=/app `
   --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
   --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
   --mount type=bind,src=$(wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
   --env-file $PSScriptRoot/../config/composer/.env `
   -p "${ADDR_PORT}:${PORT}" `
   -e TZ=${TZ} `
   --network ${NETWORK} ${LNMP_PHP_IMAGE} `
   php -S 0.0.0.0:$PORT $other
exit 0
}

docker run --init -it --rm `
  --mount type=bind,src=$(wslpath $PWD),target=/app `
  --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$(wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
  --env-file $PSScriptRoot/../config/composer/.env `
  -e APP_ENV=development `
  -e TZ=${TZ} `
  --network ${NETWORK} `
  ${LNMP_PHP_IMAGE} `
  php $COMMAND
