#
# https://github.com/FriendsOfPHP/PHP-CS-Fixer
#

. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

docker run -it --rm `
  --mount type=bind,src=$($PWD.ProviderPath),target=/app `
  --mount type=bind,src=$PSScriptRoot/../config/php8/php-cli.ini,target=/usr/local/etc/php/php-cli.ini `
  --entrypoint gosu `
  khs1994/php:php-cs-fixer `
  ${LNMP_USER} php-cs-fixer $args
