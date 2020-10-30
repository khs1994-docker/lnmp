#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

if (!($args -contains 'new')){
  write-warning "
Example:

lnmp-laravel new [My-project] [VERSION:-7]"
  exit 1
}

if ($args.Count -lt 2 ){
    write-warning "
Example:

lnmp-laravel new [My-project] [VERSION:-7]"
    exit 1
}

$LARAVEL_PATH=$args[1]

if (!$args[2]){
  $VERSION=7
}else{
  $VERSION=$args[2]
}

if (!(Test-Path ${LARAVEL_PATH})){

docker run -it --rm `
    --mount type=bind,src=$(wslpath $PWD),target=/app `
    --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
    --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
    --mount type=bind,src=$( wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
    --env-file $PSScriptRoot/../config/composer/.env `
    -e LARAVEL_PATH=${LARAVEL_PATH} `
    khs1994/php:7.4.12-composer-alpine `
    composer create-project --prefer-dist laravel/laravel=$VERSION.* "$LARAVEL_PATH"

# tar -zxvf .\${LARAVEL_PATH}.tar.gz
}else{
  write-warning "${LARAVEL_PATH} existing"
  exit 1
}
