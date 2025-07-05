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

$LNMP_DOCKER_IMAGE_PREFIX=GET-ENV LNMP_DOCKER_IMAGE_PREFIX "$PSScriptRoot/../.env" library
$LNMP_PHP8_VERSION=GET-ENV LNMP_PHP8_VERSION "$PSScriptRoot/../.env" library
$LNMP_LIBRARY_NS=GET-ENV LNMP_LIBRARY_NS "$PSScriptRoot/../.env" library

docker run -it --rm `
  -v lnmp_composer-cache-data:${COMPOSER_CACHE_DIR} `
  -v lnmp_composer_home-data,target=${COMPOSER_HOME} `
  -v $PSScriptRoot/../config/composer/config.json:${COMPOSER_HOME}/config.json `
  --network none `
  ${LNMP_LIBRARY_NS}/bash `
  bash -c `
  "set -x; `
   mkdir -p ${COMPOSER_CACHE_DIR}/repo; `
   mkdir -p ${COMPOSER_CACHE_DIR}/files; `
   rm -rf ${COMPOSER_HOME}/auth.json; `
   chown -R ${LNMP_USER} ${COMPOSER_CACHE_DIR}; `
   chown -R ${LNMP_USER} ${COMPOSER_HOME}; `
  "

docker run -it --rm `
    -v ${PWD}:/app `
    -v lnmp_composer-cache-data:${COMPOSER_CACHE_DIR} `
    -v lnmp_composer_home-data:${COMPOSER_HOME} `
    -v $PSScriptRoot\..\config\composer\config.json:${COMPOSER_HOME}/config.json `
    -v $PSScriptRoot/../config/php8/php-cli.ini:/usr/local/etc/php/php-cli.ini `
    --env-file $PSScriptRoot/../config/composer/.env `
    --env PATH=${COMPOSER_HOME}/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin `
    --network ${NETWORK} `
    ${LNMP_DOCKER_IMAGE_PREFIX}/php:${LNMP_PHP8_VERSION}-composer-alpine `
    gosu ${LNMP_USER} composer $args

$end_at=date

echo "
######################################
*     start: ${start_at}     *
*                                    *
*     end:   ${end_at}     *
######################################
"
