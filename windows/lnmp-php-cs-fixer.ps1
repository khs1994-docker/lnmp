#
# https://github.com/FriendsOfPHP/PHP-CS-Fixer
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

docker run -it --rm `
  --mount type=bind,src=$PWD,target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$PSScriptRoot/../config/composer/config.json,target=${COMPOSER_HOME}/config.json `
  --env-file $PSScriptRoot/../config/composer/.env `
  --entrypoint php-cs-fixer `
  ${LNMP_PHP_IMAGE} `
  $args
