#
# https://github.com/composer/composer
#

. "$PSScriptRoot/common.ps1"

# docker run -it --rm `
#     --mount type=bind,src=$PWD,target=/app `
#     --mount src=lnmp_composer_cache-data,target=/tmp/cache `
#     --entrypoint /docker-entrypoint.composer.sh `
#     khs1994/php:7.2.13-composer-alpine `
     composer $args
