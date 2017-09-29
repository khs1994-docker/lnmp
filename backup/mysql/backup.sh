#!/bin/bash

BACKUP_DATABASES=test

mysqldump -uroot -p${MYSQL_ROOT_PASSWORD} ${BACKUP_DATABASES} > /backup/"$(date "+%Y%m%d-%H.%M")".sql
