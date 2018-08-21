#!/usr/bin/env bash

set -ex

if [ ! -n "$1" ] ;then
  echo -e "Usage: lnmp-backup [OPTIONS] database [tables]
OR     lnmp-backup [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
OR     lnmp-backup [OPTIONS] --all-databases [OPTIONS]
For more options, use lnmp-backup --help
"
else
  mysqldump -uroot -p"$(< /run/secrets/db_root_password)" "$@" > /backup/"$(date "+%Y%m%d-%H.%M")".sql
fi
