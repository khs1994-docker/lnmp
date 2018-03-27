#!/bin/bash

set -ex

if [ ! -n "$1" ] ;then
  echo "请传入 SQL 文件名"
  cd /backup
  echo `ls *.sql`
else
  FILE_NAME=$1
  mysql -uroot -p"$(< /run/secrets/db_root_password)" < /backup/${FILE_NAME}
fi
