#
# https://github.com/composer/composer
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

$start_at=date

mkdir -Force vendor > $null 2>&1

docker run -it --rm `
  --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$PSScriptRoot/../config/composer/config.json,target=${COMPOSER_HOME}/config.json `
  --network none `
  bash `
  bash -c `
  "set -x; `
   mkdir -p ${COMPOSER_CACHE_DIR}/repo; `
   mkdir -p ${COMPOSER_CACHE_DIR}/files; `
   rm -rf ${COMPOSER_HOME}/auth.json; `
   chown -R ${LNMP_USER} ${COMPOSER_CACHE_DIR}; `
   chown -R ${LNMP_USER} ${COMPOSER_HOME}; `
  "

docker run -it --rm `
    --mount type=bind,src=$($PWD.ProviderPath),target=/app `
    --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
    --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
    --mount type=bind,src=$(Get-ChildItem $PSScriptRoot\..\config\composer\config.json),target=${COMPOSER_HOME}/config.json `
    --mount type=bind,src=$PSScriptRoot/../config/php8/php-cli.ini,target=/usr/local/etc/php/php-cli.ini `
    --env-file $PSScriptRoot/../config/composer/.env `
    --env PATH=${COMPOSER_HOME}/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin `
    --network ${NETWORK} `
    ${LNMP_PHP_IMAGE} `
    gosu ${LNMP_USER} composer $args

$end_at=date

echo "
######################################
*     start: ${start_at}     *
*                                    *
*     end:   ${end_at}     *
######################################
"
