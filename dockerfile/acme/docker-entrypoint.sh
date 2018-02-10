#!/bin/sh

export LE_WORKING_DIR="/root/.acme.sh"

export PATH=/root/.acme.sh:$PATH

alias acme.sh="/root/.acme.sh/acme.sh"

issue(){
  echo "正在申请证书 ..." ; echo
  first=$1
  shift
  acme.sh --issue \
          --debug \
          --dns dns_dp \
          --keylength ec-256 \
          -d $first "$@"

  if [ $? = 0 ];then install $first; fi
}

install(){
  echo "开始转移证书到 /ssl ..." ; echo

  acme.sh --install-cert \
    --debug\
    -d $1 \
    --key-file /ssl/$1.key \
    --fullchain-file /ssl/$1.crt \
    --ecc
}

# 传入 bash sh

if [ "$1" = bash ] || [ "$1" = sh ];then exec /bin/sh; fi

# 传入 acme.sh ...

if [ "$1" = 'acme.sh' ];then exec "$@"; fi

# 存在环境变量

if [ "$DNS_TYPE" = 'dns_dp' ];then issue "$@"; fi
