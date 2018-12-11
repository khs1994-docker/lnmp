#
# https://github.com/laravel/laravel
#

. "$PSScriptRoot/common.ps1"

if (!($args -contains 'new')){
  exit 1
}

if ($args.Count -lt 2 ){
    exit 1
}

$global:LARAVEL_PATH=$args[1]

if (!(Test-Path ${LARAVEL_PATH})){
  echo ""
  echo "${LARAVEL_PATH} not existing"
  echo ""
# docker run -it --rm `
#     --mount type=bind,src=$PWD,target=/app `
#     --mount src=lnmp_composer_cache-data,target=/tmp/cache `
#     --mount type=bind,src=$env:LNMP_PATH/windows/docker-entrypoint.laravel.sh,target=/docker-entrypoint.laravel.sh `
#     --entrypoint /docker-entrypoint.laravel.sh `
#     --workdir /tmp `
#     -e LARAVEL_PATH=${LARAVEL_PATH} `
#     khs1994/php:7.2.13-composer-alpine `
    composer create-project --prefer-dist laravel/laravel=5.5.* "$LARAVEL_PATH"

# tar -zxvf .\${LARAVEL_PATH}.tar.gz
}else{
  echo ""
  echo "${LARAVEL_PATH} existing"
  echo ""
}

cd ${LARAVEL_PATH}

. "$PSScriptRoot/lnmp-laravel-init.ps1"

cd ..
