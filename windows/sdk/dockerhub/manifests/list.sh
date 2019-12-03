list(){
  local token=$1
  local image=$2
  local ref=$3
  local header=$4
  local registry=${5:-registry.hub.docker.com}

  if [ -z "${header}" ];then
    header="application/vnd.docker.distribution.manifest.list.v2+json"

    echo "==> Get manifest list" > /dev/stderr
  fi

  image_conver=`echo $image | sed 's#/#@#g'`
  ref_conver=`echo $ref | sed 's#sha256:##g'`

  local cache_file=`getCachePath \
        "manifest@${registry}@${image_conver}@${ref_conver}.json" `

curl \
-H "Authorization:Bearer $token" \
-H "Accept:$header" \
"https://$registry/v2/$image/manifests/$ref" \
-A "Docker-Client/19.03.5 (Linux)" \
-o $cache_file

echo $cache_file

}
