#!/usr/bin/env bash

set -ex

COMMIT=`date "+%F %T"`

push(){
  cd $1
  if [ -d .git ];then
    git add . \
    && git commit -m "${COMMIT}" \
    && git push -f origin master
  fi
}

push "/data/lnmp/app/admin"
push "/data/lnmp/config/nginx"
