#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

if ($args[0] -eq 'new' ){
  if ($args.Count -lt 2 ){
    write-warning "Please input path!"
    exit 1
  }

  $LARAVEL_PATH=$args[1]

  if (Test-Path ${LARAVEL_PATH}){
    write-warning "${LARAVEL_PATH} existing"
    exit 1
  }

  echo ""
  echo "==>Installing laravel ..."
  echo ""
}

docker run --init -it --rm `
    --mount type=bind,src=$(wslpath $PWD),target=/app `
    --mount src=lnmp_composer_cache-data,target=${COMPOSER_CACHE_DIR} `
    --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
    --mount type=bind,src=$(wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
    --env-file $PSScriptRoot/../config/composer/.env `
    khs1994/php:7.4.3-composer-alpine `
    laravel $args

# composer create-project --prefer-dist laravel/laravel=5.8.* "$LARAVEL_PATH"

if ($args[0] -eq 'new' ){
  cd ${LARAVEL_PATH}

  . "$PSScriptRoot/lnmp-laravel-init.ps1"

  cd ..

}
