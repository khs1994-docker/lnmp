#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/common.ps1"

if ($args -contains 'new' ){
  if ($args.Count -lt 2 ){
    exit 1
  }
}

$global:LARAVEL_PATH=$args[1]

if (!(Test-Path ${LARAVEL_PATH})){
  echo ""
  echo "${LARAVEL_PATH} not existing, laravel is install..."
  echo ""
# docker run --init -it --rm `
#     --mount type=bind,src=$PWD,target=/app `
#     --mount src=lnmp_composer_cache-data,target=/tmp/cache `
#     khs1994/php:7.2.13-composer-alpine `
#     laravel $args

composer create-project --prefer-dist laravel/laravel=5.6.* "$LARAVEL_PATH"

}else{
  echo ""
  echo "${LARAVEL_PATH} existing"
  echo ""
}

if ($args -contains 'new' ){
  cd ${LARAVEL_PATH}

  . "$PSScriptRoot/lnmp-laravel-init.ps1"

  cd ..

}
