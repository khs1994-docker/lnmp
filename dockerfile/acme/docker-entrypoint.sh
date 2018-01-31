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

if [ "$1" = bash ] || [ "$1" = sh ];then exec /bin/sh; fi

# 如果参数大于等于 1

if [ "$#" -ge 1 ];then exec "$@"; fi

# 如果没有参数，并且存在 $url 环境变量

if [ "$#" = 0 ] && [ ! -z "$url" ];then issue; fi

# 之后转移证书

if [ "$?" = 0 ];then install; fi
