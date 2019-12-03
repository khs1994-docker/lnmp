getCachePath(){
local cacheDist=${1:-''}

if [ -z "$LNMP_CACHE" ];then
  LNMP_CACHE="$HOME/.khs1994-docker-lnmp"
fi

local cache_dir="${LNMP_CACHE}/dockerhub"

mkdir -p $cache_dir

echo "$cache_dir/$cacheDist"
}
