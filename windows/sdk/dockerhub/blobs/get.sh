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

_sha256_checker(){
  sha256=`basename $1 | cut -d "." -f 1`
  current_sha256=`sha256sum $1 | cut -d ' ' -f 1`

  if [ $sha256 != $current_sha256 ];then
    echo "==> $1 sha256 check failed" > /dev/stderr

    return 1
  fi
}

get(){
  local token=$1
  local image=$2
  local digest=$3
  local registry=${4:-"registry.hub.docker.com"}
  local dist=$5

  local image_conver=`echo $image | sed "s#/#@#g"`
  local digest_conver=`echo $digest | sed "s#sha256:##g"`

  mkdir -p `getCachePath blobs`

  local distTemp=`getCachePath "blobs/$digest_conver.tar.gz" `

  if [ -f $distTemp ];then
    result=`_sha256_checker $distTemp && echo 0 || echo 1`

    if [ $result = "0" ];then
      echo "==> File already exists, skip download" > /dev/stderr
      getDist "${dist}" $distTemp

      return
    fi

    echo "==> File already exists, but sha256 check failed, redownload" > /dev/stderr
  fi

  curl -L \
  -H "Authorization: Bearer $token" \
  -H "Accept:application/vnd.docker.image.rootfs.diff.tar.gzip" \
  "https://$registry/v2/$image/blobs/$digest" \
  -A "Docker-Client/19.03.5 (Linux)" \
  -o $distTemp

  _sha256_checker $distTemp && getDist "${dist}" $distTemp
}
