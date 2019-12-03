#!/usr/bin/env sh

rootfs(){
  local ScriptRoot="$( cd "$( dirname "$0"  )" && pwd  )"
  . $ScriptRoot/cache/cache.sh

  local image=${1:-alpine}
  local ref=${2:-latest}
  local arch=${3:-amd64}
  local os=${4:-linux}
  local dist=$5
  local layersIndex=${6:-0}
  local registry=${7:-dockerhub.azk8s.cn}

  echo "==> get token ..." > /dev/stderr

  WWW_Authenticate=`curl https://$registry/v2/x/y/manifests/latest \
-X HEAD -I -A "Docker-Client/19.03.5 (Linux)" | grep -i 'www\-authenticate' `

if [ $? -eq 0 ];then
  realm=`echo $WWW_Authenticate | awk -F"," '{print $1}'`
  service=`echo $WWW_Authenticate | cut -d "," -f 2`

  realmKey=`echo $realm | cut -d " " -f 3 | cut -d "=" -f 1`
  if [ "$realmKey" = 'realm' ];then
    tokenServer=`echo $realm | cut -d " " -f 3 | cut -d "=" -f 2 | sed "s#'##g" | sed 's#"##g'`
  fi

  serviceKey=`echo $service | cut -d "=" -f 1`
  if [ "$serviceKey" = 'service' ];then
    tokenService=`echo "$service" | cut -d "=" -f 2 | sed 's#"##g' | sed 's#\\r##g'`
  fi
fi

  if [ -z "$tokenServer" ];then tokenServer=${8:-"https://auth.docker.io/token"} ;fi
  if [ -z "$tokenService" ];then tokenService=${9:-"registry.docker.io"} ;fi

  echo $image | grep -q '/' || image="library/$image"

  echo "
{
     \"image\" : \"$image\",
     \"ref\" : \"$ref\",
     \"arch\" : \"$arch\",
     \"os\" : \"$os\",
     \"registry\" : \"$registry\",
     \"tokenServer\" : \"$tokenServer\",
     \"tokenService\" : \"$tokenService\",
     \"layersIndex\" : \"$layersIndex\"
}
" > /dev/stderr

echo "==> wait 3s, continue ..." > /dev/stderr

sleep 3

. $ScriptRoot/auth/auth.sh

getToken $image pull $tokenServer $tokenService 0 || return 1

# echo $token

. $ScriptRoot/manifests/list.sh

manifest_list_json_file=`list "$token" "$image" "$ref" '' "$registry"`

local schemaVersion=`cat $manifest_list_json_file | jq '.schemaVersion'`

if [ "$schemaVersion" -eq 1 ];then
  echo "==> manifest list not found" > /dev/stderr

  manifest_json_file=`list $token $image $ref "application/vnd.docker.distribution.manifest.v2+json" $registry`

  local digest=`cat $manifest_json_file | jq ".layers[$layersIndex].digest" | sed 's/"//g'`

  echo "==> Digest is $digest" > /dev/stderr

  . $ScriptRoot/blobs/get.sh

  dist=`get $token $image $digest $registry "${dist}"`

  echo $dist

  return

elif [ "$schemaVersion" -eq 2 ];then
  echo "==> manifest list is found" > /dev/stderr
else
  echo "==> get manifest error, exit"

  return 1
fi

# not support sh
# for ((i=0;i<10;i++));
for i in $(seq 0 10)
do
local current_arch=`cat $manifest_list_json_file | jq ".manifests[$i].platform.architecture" | sed 's/"//g'`

if [ $current_arch = null ];then
  echo "Can't find ${image}:$ref $os $arch image" > /dev/stderr

  return
fi

local current_os=`cat $manifest_list_json_file | jq ".manifests[$i].platform.os" | sed 's/"//g'`

  if [ $current_arch = $arch -a $current_os = $os ];then
    local digest=`cat $manifest_list_json_file | jq ".manifests[$i].digest" | sed 's/"//g'`

    manifest_json_file=`list $token $image $digest "application/vnd.docker.distribution.manifest.v2+json" $registry`

    local digest=`cat $manifest_json_file | jq ".layers[$layersIndex].digest" | sed 's/"//g'`

    echo "==> Digest is $digest" > /dev/stderr

    . $ScriptRoot/blobs/get.sh

    dist=`get $token $image $digest $registry "${dist}"`

    echo $dist

    return
  fi
done
}

rootfs "$@" || exit 1
