#
# https://github.com/FriendsOfPHP/Sami
#

. "$PSScriptRoot/common.ps1"

docker run -it --rm `
  --mount type=bind,src=$PWD,target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=/tmp/cache `
  --entrypoint sami `
  -e TZ=${TZ} `
  ${LNMP_PHP_IMAGE} `
  $args
