#!/usr/bin/env bash

set -ex

if [ ! -n "$1" ] ;then
  echo -e "Usage: lnmp-backup [OPTIONS] database [tables]
OR     lnmp-backup [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
OR     lnmp-backup [OPTIONS] --all-databases [OPTIONS]
For more options, use lnmp-backup --help
"
else
  if [ -f /run/secrets/db_root_password ];then
    PASSWORD=`head -1 /run/secrets/db_root_password`
  else
    PASSWORD=${MYSQL_ROOT_PASSWORD}
  fi
  # mysqldump -uroot -p"$(< /run/secrets/db_root_password)" "$@" > /backup/"$(date "+%Y%m%d-%H.%M.%S")".sql
  mysqldump -uroot -p${PASSWORD} "$@" > /backup/"$(date "+%Y%m%d-%H.%M.%S")".sql
fi
