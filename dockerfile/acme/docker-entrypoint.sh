#!/bin/sh

export LE_WORKING_DIR="/root/.acme.sh"

export PATH=/root/.acme.sh:$PATH

alias acme.sh="/root/.acme.sh/acme.sh"

issue(){
  echo "正在申请证书 ..." ; echo

  acme.sh --issue \
          --debug \
          --dns $DNS_TYPE \
          -d $url \
          --keylength ec-256
}

install(){
  echo "开始转移证书到 /ssl ..." ; echo

  acme.sh --install-cert \
    --debug\
    -d $url \
    --key-file /ssl/$url.key \
    --fullchain-file /ssl/$url.crt \
    --ecc
}

echo $1

if [ "$1" = bash ];then exec /bin/sh; fi

if [ "$#" = 1 ];then exec "$@"; fi

if [ "$#" -gt 1 ];then exec "$@"; fi

if [ "$#" = 0 ];then issue; fi

if [ "$?" = 0 ];then install; fi
