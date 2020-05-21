#
# https://github.com/sebastianbergmann/phpunit
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

if ($?){
  $create=$true
}

if (! (Test-Path vendor\bin\phpunit)){
  echo "
PHPUnit not found, You Must EXEC

$ lnmp-composer require phpunit

OR

$ lnmp-composer install
"

exit 1

}

docker run -it --init --rm `
    --mount type=bind,src=$(wslpath $PWD),target=/app `
    --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
    --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
    --mount type=bind,src=$(wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
    --env-file $PSScriptRoot/../config/composer/.env `
    --network ${NETWORK} `
    ${LNMP_PHP_IMAGE} `
    vendor/bin/phpunit $args
