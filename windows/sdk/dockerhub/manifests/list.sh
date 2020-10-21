list(){
  local token=$1
  local image=$2
  local ref=$3
  local header=$4
  local registry=${5:-registry.hub.docker.com}

  local header_default="application/vnd.docker.distribution.manifest.list.v2+json"

  if [ -z "${header}" ];then
    header=$header_default

    echo "==> Get manifest list ..." > /dev/stderr
  fi

  image_conver=`echo $image | sed 's#/#@#g'`
  ref_conver=`echo $ref | sed 's#sha256:##g'`

  mkdir -p `getCachePath manifests`

  local cache_file=`getCachePath "manifests/${ref_conver}.json" `

curl -fsSL \
-H "Authorization:Bearer $token" \
-H "Accept:$header" \
"https://$registry/v2/$image/manifests/$ref" \
-A "Docker-Client/19.03.5 (Linux)" \
-o $cache_file

errorCode=`cat $cache_file | jq '.errors[0].code' | sed 's#"##g'`

if [ "$errorCode" = "MANIFEST_UNKNOWN" -a $header = $header_default ];then
  echo "==> Get manifest list error, try get manifest ..." > /dev/stderr

  echo '{"schemaVersion":1}' > $cache_file

fi

echo $cache_file

}
