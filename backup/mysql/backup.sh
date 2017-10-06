#!/bin/bash

if [ ! -n "$1" ] ;then
  echo -e "请传入参数
database [tables]
--databases [OPTIONS] DB1 [DB2 DB3...]
--all-databases [OPTIONS]
"
else
  mysqldump -uroot -p${MYSQL_ROOT_PASSWORD} "$@" > /backup/"$(date "+%Y%m%d-%H.%M")".sql
fi
