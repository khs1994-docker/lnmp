#
# https://github.com/FriendsOfPHP/PHP-CS-Fixer
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

docker run -it --rm `
  -v ${PWD}:/app `
  -v $PSScriptRoot/../config/php8/php-cli.ini:/usr/local/etc/php/php-cli.ini `
  --entrypoint gosu `
  khs1994/php:php-cs-fixer `
  ${LNMP_USER} php-cs-fixer $args
