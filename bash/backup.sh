#!/bin/bash

COMMIT=`date "+%F %T"`

function push(){
  git add . \
  && git commit -m "${COMMIT}" \
  && git push -f origin master
}

cd /data/lnmp/app/admin \
   && push

cd /data/lnmp/config/nginx \
   && push
