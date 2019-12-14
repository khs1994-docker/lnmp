. "$PSScriptRoot/common.ps1"
. "$PSScriptRoot/../config/composer/.env.example.ps1"
. "$PSScriptRoot/../config/composer/.env.ps1"

if ($args.count -lt 1){
  exit 1
}

docker run -it --rm `
  --mount type=bind,src=$(wslpath $PWD),target=/app,consistency=cached `
  --mount src=lnmp_composer_cache-data,target=${COMPOSER_CACHE_DIR} `
  --mount src=lnmp_composer_home-data,target=${COMPOSER_HOME} `
  --mount type=bind,src=$(wslpath $PSScriptRoot/../config/composer/config.json),target=${COMPOSER_HOME}/config.json `
  --env-file $PSScriptRoot/../config/composer/.env `
  ${LNMP_PHP_IMAGE} `
  composer create-project topthink/think=5.0.* $args[0] --prefer-dist

#   --entrypoint /docker-entrypoint.composer `
