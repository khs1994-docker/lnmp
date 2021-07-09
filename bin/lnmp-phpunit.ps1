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
    --mount type=bind,src=$($PWD.ProviderPath),target=/app `
    --mount type=bind,src=$PSScriptRoot/../config/php8/php-cli.ini,target=/usr/local/etc/php/php-cli.ini `
    --mount type=bind,src=$PSScriptRoot/../log/php/cli_error.log,target=/var/log/php/php_errors.log `
    --network ${NETWORK} `
    --env-file $PSScriptRoot/../config/composer/.env `
    --entrypoint gosu `
    -e APP_ENV=testing `
    -e TZ=${TZ} `
    ${LNMP_PHP_IMAGE} `
    ${LNMP_USER} ./vendor/bin/phpunit -d zend_extension=xdebug -d error_log=/var/log/php/php_errors.log $args
