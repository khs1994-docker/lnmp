#
# https://github.com/FriendsOfPHP/Sami
#

. "$PSScriptRoot/common.ps1"

docker run -it --rm `
  --mount type=bind,src=$(wslpath $PWD),target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$(wslapth $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
  --env-file $PSScriptRoot/../config/composer/.env `
  --entrypoint sami `
  -e TZ=${TZ} `
  khs1994/sami `
  $args
