#
# https://github.com/sebastianbergmann/phpunit
#

. "$PSScriptRoot/.env.example.ps1"

if (Test-Path "$PSScript/.env.ps1"){
  . "$PSScriptRoot/.env.ps1"
}

docker network create lnmp_backend | Out-Null

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
    --mount type=bind,src=$PWD,target=/app `
    --mount src=lnmp_composer_cache-data,target=/tmp/cache `
    --network lnmp_backend `
    ${LNMP_PHP_IMAGE} `
    vendor/bin/phpunit $args
