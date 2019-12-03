getDist(){
  dist=$1
  local distTemp=$2

  if [ -n "${dist}" ];then
    cp $distTemp $dist
    echo $dist

    return
  fi

  echo $distTemp
}

get(){
  local token=$1
  local image=$2
  local digest=$3
  local registry=${4:-"registry.hub.docker.com"}
  local dist=$5

  local image_conver=`echo $image | sed "s#/#@#g"`
  local digest_conver=`echo $digest | sed "s#sha256:##g"`

  local distTemp=`getCachePath \
  "${registry}@$image_conver@$digest_conver.tar.gz" `

  if [ -f $distTemp ];then
    echo "==> file already exists, skip download" > /dev/stderr

    getDist "${dist}" $distTemp

    return
  fi

  curl -L \
  -H "Authorization: Bearer $token" \
  -H "Accept:application/vnd.docker.image.rootfs.diff.tar.gzip" \
  "https://$registry/v2/$image/blobs/$digest" \
  -A "Docker-Client/19.03.5 (Linux)" \
  -o $distTemp

  getDist "${dist}" $distTemp
}
