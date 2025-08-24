#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

$LARAVEL_VERSION=12

if (!($args -contains 'new')){
  write-warning "
Example:

lnmp-laravel new [My-project] [VERSION:-$LARAVEL_VERSION]"
  exit 1
}

if ($args.Count -lt 2 ){
    write-warning "
Example:

lnmp-laravel new [My-project] [VERSION:-$LARAVEL_VERSION]"
    exit 1
}

$LARAVEL_PATH=$args[1]

if (!$args[2]){
  $VERSION=12
}else{
  $VERSION=$args[2]
}

$LNMP_DOCKER_IMAGE_PREFIX=GET-ENV LNMP_DOCKER_IMAGE_PREFIX "$PSScriptRoot/../.env" khs1994
$LNMP_PHP8_VERSION=GET-ENV LNMP_PHP8_VERSION "$PSScriptRoot/../.env" "8.4.11"
$LNMP_LIBRARY_NS=GET-ENV LNMP_LIBRARY_NS "$PSScriptRoot/../.env" library

if ((!(Test-Path ${LARAVEL_PATH})) -or ${LARAVEL_PATH} -eq '.'){

  docker run -it --rm `
  -v lnmp_composer-cache-data:${COMPOSER_CACHE_DIR} `
  -v lnmp_composer_home-data:${COMPOSER_HOME} `
  -v $PSScriptRoot/../config/composer/config.json:${COMPOSER_HOME}/config.json `
  --network none `
  ${LNMP_LIBRARY_NS}/bash `
  bash -c `
  "set -x; `
   mkdir -p ${COMPOSER_CACHE_DIR}/repo; `
   mkdir -p ${COMPOSER_CACHE_DIR}/files; `
   rm -rf ${COMPOSER_HOME}/auth.json; `
   chown -R ${LNMP_USER} ${COMPOSER_CACHE_DIR}; `
   chown -R ${LNMP_USER} ${COMPOSER_HOME}; `
  "

  docker run -it --rm `
    -v ${PWD}:/app `
    -v lnmp_composer-cache-data:${COMPOSER_CACHE_DIR} `
    -v lnmp_composer_home-data:${COMPOSER_HOME} `
    -v $PSScriptRoot\..\config\composer\config.json:${COMPOSER_HOME}/config.json `
    -v $PSScriptRoot\..\config/php8/php-cli.ini:/usr/local/etc/php/php-cli.ini `
    --env-file $PSScriptRoot/../config/composer/.env.example `
    --env-file $PSScriptRoot/../config/composer/.env `
    -e LARAVEL_PATH=${LARAVEL_PATH} `
    ${LNMP_DOCKER_IMAGE_PREFIX}/php:${LNMP_PHP8_VERSION}-composer-alpine `
    gosu ${LNMP_USER} composer create-project --prefer-dist laravel/laravel=$VERSION.* "$LARAVEL_PATH"

# tar -zxvf .\${LARAVEL_PATH}.tar.gz
}else{
  write-warning "${LARAVEL_PATH} existing"
  exit 1
}
