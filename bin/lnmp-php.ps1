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
   --mount type=bind,src=$($PWD.ProviderPath),target=/app `
   --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
   --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
   --mount type=bind,src=$PSScriptRoot/../config/php8/php-cli.ini,target=/usr/local/etc/php/php-cli.ini `
   --mount type=bind,src=$PSScriptRoot/../log/php/cli_error.log,target=/var/log/php/php_errors.log `
   --mount type=bind,src=$(Get-ChildItem $PSScriptRoot\..\config\composer\config.json),target=${COMPOSER_HOME}/config.json `
   --network ${NETWORK} `
   --env-file $PSScriptRoot/../config/composer/.env `
   -e APP_ENV=${APP_ENV} `
   -e TZ=${TZ} `
   -p "${ADDR_PORT}:${PORT}" `
   ${LNMP_PHP_IMAGE} `
   gosu ${LNMP_USER} php -d zend_extension=xdebug -d error_log=/var/log/php/php_errors.log -S 0.0.0.0:$PORT $other

   exit 0
}

docker run -it --rm `
  --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$PSScriptRoot/../config/composer/config.json,target=${COMPOSER_HOME}/config.json `
  --network none `
  bash `
  bash -c `
  "set -x; `
   mkdir -p ${COMPOSER_CACHE_DIR}/repo; `
   mkdir -p ${COMPOSER_CACHE_DIR}/files; `
   rm -rf ${COMPOSER_HOME}/auth.json; `
   chown -R ${LNMP_USER} ${COMPOSER_CACHE_DIR}; `
   chown -R ${LNMP_USER} ${COMPOSER_HOME}; `
  "

docker run --init -it --rm `
  --mount type=bind,src=$($PWD.ProviderPath),target=/app `
  --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$PSScriptRoot/../config/php8/php-cli.ini,target=/usr/local/etc/php/php-cli.ini `
  --mount type=bind,src=$PSScriptRoot/../log/php/cli_error.log,target=/var/log/php/php_errors.log `
  --mount type=bind,src=$(Get-ChildItem $PSScriptRoot\..\config\composer\config.json),target=${COMPOSER_HOME}/config.json `
  --network ${NETWORK} `
  --env-file $PSScriptRoot/../config/composer/.env `
  -e TZ=${TZ} `
  -e APP_ENV=development `
  ${LNMP_PHP_IMAGE} `
  gosu ${LNMP_USER} php -d zend_extension=xdebug -d error_log=/var/log/php/php_errors.log $COMMAND
