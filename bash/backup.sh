#!/bin/bash

COMMIT=`date "+%F %T"`

function push(){
  cd $1
  git add . \
  && git commit -m "${COMMIT}" \
  && git push -f origin master
}

push "/data/lnmp/app/admin"
push "/data/lnmp/config/nginx"
