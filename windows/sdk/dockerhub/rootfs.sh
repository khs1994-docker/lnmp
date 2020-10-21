#!/usr/bin/env bash

rootfs(){
  local ScriptRoot="$( cd "$( dirname "$0"  )" && pwd  )"
  . $ScriptRoot/cache/cache.sh

  local image=${1:-alpine}
  local ref=${2:-latest}
  local arch=${3:-amd64}
  local os=${4:-linux}
  local dest=$5 # dest 下载到哪里
  local layersIndex=${6:-0}

  registry="hub-mirror.c.163.com"
  # registry="mirror.baidubce.com"
  if [ "$LNMP_CN_ENV" = 'false' ];then registry=registry.hub.docker.com; fi
  if [ -n "${REGISTRY_MIRROR}" ];then registry=${REGISTRY_MIRROR}; fi
  if [ -n "$7" ];then registry=$7; fi

  echo $image | grep -q '/' || image="library/$image"

  echo "
{
     \"image\" : \"$image\",
     \"ref\" : \"$ref\",
     \"arch\" : \"$arch\",
     \"os\" : \"$os\",
     \"registry\" : \"$registry\",
     \"layersIndex\" : \"$layersIndex\"
}
" > /dev/stderr

echo "==> Get token ..." > /dev/stderr
. $ScriptRoot/auth/auth.sh

getToken $image pull $registry 0 || return 1

if [ -z "$token" ];then
  echo "==> get token error

Please check DOCKER_USERNAME DOCKER_PASSWORD env value
" > /dev/stderr

  return 1

fi

# echo $token

. $ScriptRoot/manifests/list.sh

manifest_list_json_file=`list "$token" "$image" "$ref" '' "$registry"`

local schemaVersion=`cat $manifest_list_json_file | jq '.schemaVersion'`

if [ "$schemaVersion" = 1 ];then
  # cat $manifest_list_json_file > /dev/stderr

  echo "==> manifest list not found" > /dev/stderr

  manifest_json_file=`list $token $image $ref "application/vnd.docker.distribution.manifest.v2+json" $registry`

  local digest=`cat $manifest_json_file | jq ".layers[$layersIndex].digest" | sed 's/"//g'`

  if [ "${digest}" = 'null' ];then
    echo "==> [error] get blob error" > /dev/stderr

    exit 1
  fi

  echo "==> Digest: $digest" > /dev/stderr

  . $ScriptRoot/blobs/get.sh

  dest=`get $token $image $digest $registry "${dest}"`

  echo "==> Download success to $dest" > /dev/stderr

  echo $dest

  return

elif [ "$schemaVersion" = 2 ];then
  true
else
  echo "==> get manifest error, exit" > /dev/stderr

  return 1
fi

# not support sh
# for ((i=0;i<10;i++));
for i in $(seq 0 10)
do
local current_arch=`cat $manifest_list_json_file | jq ".manifests[$i].platform.architecture" | sed 's/"//g'`

if [ $current_arch = null ];then
  echo "==> Can't find ${image}:$ref $os $arch image" > /dev/stderr

  return
fi

local current_os=`cat $manifest_list_json_file | jq ".manifests[$i].platform.os" | sed 's/"//g'`

  if [ $current_arch = $arch -a $current_os = $os ];then
    local digest=`cat $manifest_list_json_file | jq ".manifests[$i].digest" | sed 's/"//g'`

    manifest_json_file=`list $token $image $digest "application/vnd.docker.distribution.manifest.v2+json" $registry`

    local digest=`cat $manifest_json_file | jq ".layers[$layersIndex].digest" | sed 's/"//g'`

    echo "==> Digest: $digest" > /dev/stderr

    . $ScriptRoot/blobs/get.sh

    dest=`get $token $image $digest $registry "${dest}"`

    echo "==> Download success to $dest" > /dev/stderr

    echo $dest

    return
  fi
done
}

rootfs "$@" || exit 1
