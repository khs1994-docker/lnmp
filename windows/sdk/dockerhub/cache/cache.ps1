
function getCachePath($path=$null){
if(!$env:LNMP_CACHE){
  $LNMP_CACHE="$home\.khs1994-docker-lnmp"
}

$cache_dir="${LNMP_CACHE}\dockerhub"

mkdir -Force $cache_dir > $null 2>&1

return "$cache_dir\$path"
}
