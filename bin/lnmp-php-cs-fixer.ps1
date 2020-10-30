#
# https://github.com/FriendsOfPHP/PHP-CS-Fixer
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

docker run -it --rm `
  --mount type=bind,src=$(wslpath $PWD),target=/app,consistency=cached `
  --mount src=lnmp_composer-cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$(wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
  --env-file $PSScriptRoot/../config/composer/.env `
  --entrypoint php-cs-fixer `
  khs1994/php:php-cs-fixer `
  $args
