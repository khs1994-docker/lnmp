#!/usr/bin/env bash

set -ex

if [ ! -n "$1" ] ;then
  echo "Please input SQL filename"
  cd /backup
  echo `ls *.sql`
else
  FILE_NAME=$1
  if [ -f /run/secrets/db_root_password ];then
    PASSWORD=`head -1 /run/secrets/db_root_password`
  else
    PASSWORD=${MYSQL_ROOT_PASSWORD}
  fi
  # mysql -uroot -p"$(< /run/secrets/db_root_password)" < /backup/${FILE_NAME}
  mysql -uroot -p${PASSWORD} < /backup/${FILE_NAME}
fi
