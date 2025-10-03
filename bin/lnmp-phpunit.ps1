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

$LNMP_DOCKER_IMAGE_PREFIX=GET-ENV LNMP_DOCKER_IMAGE_PREFIX "$PSScriptRoot/../.env" khs1994
$LNMP_PHP8_VERSION=GET-ENV LNMP_PHP8_VERSION "$PSScriptRoot/../.env" "8.4.11"

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
    -v ${PWD}:/app `
    -v $PSScriptRoot/../config/php8/php-cli.ini:/usr/local/etc/php/php-cli.ini `
    -v $PSScriptRoot/../log/php/cli_error.log:/var/log/php/php_errors.log `
    --network ${NETWORK} `
    --env-file $PSScriptRoot/../config/composer/.env `
    --entrypoint gosu `
    -e APP_ENV=testing `
    -e TZ=${TZ} `
    ${LNMP_DOCKER_IMAGE_PREFIX}/php:${LNMP_PHP8_VERSION}-composer-alpine `
    ${LNMP_USER} ./vendor/bin/phpunit -d zend_extension=xdebug -d error_log=/var/log/php/php_errors.log $args
