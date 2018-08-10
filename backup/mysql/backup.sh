#!/usr/bin/env bash

set -ex

if [ ! -n "$1" ] ;then
  echo -e "command is empty, please input something

DATABASE_NAME [tables]
--databases [OPTIONS] DB1 [DB2 DB3...]
--all-databases [OPTIONS]
"
else
  mysqldump -uroot -p"$(< /run/secrets/db_root_password)" "$@" > /backup/"$(date "+%Y%m%d-%H.%M")".sql
fi
