#
# https://github.com/sebastianbergmann/phpunit
#

. "$PSScriptRoot/common.ps1"

$create=$false

docker network create lnmp_backend | Out-Null

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
    --mount type=bind,src=$PWD,target=/app `
    --mount src=lnmp_composer_cache-data,target=/tmp/cache `
    --network lnmp_backend `
    ${LNMP_PHP_IMAGE} `
    vendor/bin/phpunit $args

if($create){
  docker network rm lnmp_backend
}
