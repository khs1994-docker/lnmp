#!/bin/sh

# 传入 bash sh

if [ "$1" = bash ] || [ "$1" = sh ];then exec /bin/sh; fi

# 传入 acme.sh ...

if [ "$1" = 'acme.sh' ];then exec "$@"; fi

echo ; echo ; echo "DNS_TYPE: ${DNS_TYPE}" ; echo ; echo

acme.sh -v

echo

# SELF ENV

# HTTPD

# RSA

if [ "$RSA" = '0' ];then
  # 是 ECC 证书
  echo "ECC"; echo ; echo
  unset RSA
  ECC='--ecc'
else
  # 不是 ECC 证书
  echo "RSA"; echo ; echo
  RSA="--keylength 2048"
  RSA_FILE='.rsa.'
fi

set -e

issue(){
  echo "正在申请证书 ..." ; echo ; echo
  first_domain=$1
  shift
  acme.sh --issue \
          --dns ${DNS_TYPE:-dns_dp} \
          ${RSA:---keylength ec-256} \
          -d $first_domain "$@"

  install $first_domain
}

install(){
  echo "开始转移证书到 /ssl ..." ; echo ; echo

  if [ "${HTTPD}" = '1' ];then
    echo "HTTPD..."; echo; echo
    acme.sh --install-cert \
      -d $1 \
      --cert-file  /ssl/$1${RSA_FILE:-.}crt  \
      --key-file   /ssl/$1${RSA_FILE:-.}key  \
      --fullchain-file /ssl/$1${RSA_FILE:-.}fullchain.crt \
      ${ECC:- }

  else
    echo "NGINX..."; echo ; echo
    acme.sh --install-cert \
      -d $1 \
      --key-file /ssl/$1${RSA_FILE:-.}key \
      --fullchain-file /ssl/$1${RSA_FILE:-.}crt \
      ${ECC:- }
  fi
}

issue "$@"
