#!/usr/bin/env bash

set -ex

if [ ! -n "$1" ] ;then
  echo "please input SQL filename"
  cd /backup
  echo `ls *.sql`
else
  FILE_NAME=$1
  mysql -uroot -p"$(< /run/secrets/db_root_password)" < /backup/${FILE_NAME}
fi
