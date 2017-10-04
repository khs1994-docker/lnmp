#!/bin/bash

if [ ! -n "$1" ] ;then
  echo "请传入 SQL 文件名"
  cd /backup
  echo `ls *.sql`
else
  FILE_NAME=$1
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /backup/${FILE_NAME}
fi
