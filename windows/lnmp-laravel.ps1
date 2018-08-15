#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/.env.example.ps1"

if (Test-Path "$PSScriptRoot/.env.ps1"){
  . "$PSScriptRoot/.env.ps1"
}

if ($args -contains 'new' ){
  if ($args.Count -lt 2 ){
    exit 1
  }
}

if (!(Test-Path ${LARAVEL_PATH})){
  echo ""
  echo "${LARAVEL_PATH} not existing"
  echo ""
# docker run --init -it --rm `
#     --mount type=bind,src=$PWD,target=/app `
#     --mount src=lnmp_composer_cache-data,target=/tmp/cache `
#     $LNMP_PHP_IMAGE `
#     laravel $args

composer create-project --prefer-dist laravel/laravel=5.6.* "$LARAVEL_PATH"

}else{
  echo ""
  echo "${LARAVEL_PATH} existing"
  echo ""
}

if ($args -contains 'new' ){
  $global:LARAVEL_PATH=$args[1]

  cd ${LARAVEL_PATH}

  . "$PSScriptRoot/lnmp-laravel-init.ps1"

  cd ..

}
