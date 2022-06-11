#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

if (!($args -contains 'new')){
  write-warning "
Example:

lnmp-laravel new [My-project] [VERSION:-9]"
  exit 1
}

if ($args.Count -lt 2 ){
    write-warning "
Example:

lnmp-laravel new [My-project] [VERSION:-9]"
    exit 1
}

$LARAVEL_PATH=$args[1]

if (!$args[2]){
  $VERSION=9
}else{
  $VERSION=$args[2]
}

if (!(Test-Path ${LARAVEL_PATH})){

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

docker run -it --rm `
    --mount type=bind,src=$($PWD.ProviderPath),target=/app `
    --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
    --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
    --mount type=bind,src=$(Get-ChildItem $PSScriptRoot\..\config\composer\config.json),target=${COMPOSER_HOME}/config.json `
    --mount type=bind,src=$PSScriptRoot/../config/php8/php-cli.ini,target=/usr/local/etc/php/php-cli.ini `
    --env-file $PSScriptRoot/../config/composer/.env `
    -e LARAVEL_PATH=${LARAVEL_PATH} `
    ${LNMP_PHP_IMAGE} `
    gosu ${LNMP_USER} composer create-project --prefer-dist laravel/laravel=$VERSION.* "$LARAVEL_PATH"

# tar -zxvf .\${LARAVEL_PATH}.tar.gz
}else{
  write-warning "${LARAVEL_PATH} existing"
  exit 1
}
