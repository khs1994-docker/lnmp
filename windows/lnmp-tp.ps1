. "$PSScriptRoot/common.ps1"

if ($args.count -lt 1){
  exit 1
}

docker run -it --rm `
  --mount type=bind,src=$PWD,target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=/tmp/cache `
  --entrypoint /docker-entrypoint.composer.sh `
  ${LNMP_PHP_IMAGE} `
  composer create-project topthink/think=5.0.* $args[0] --prefer-dist
