#!/bin/bash

set -e

DB_ROOT_PASSWORD=$(cat /etc/mysql/db_root_password)

export MYSQL_PWD=${DB_ROOT_PASSWORD}

# MySQL Docker 8.0.4 based stretch(Debian 9) Remove ip ping etc command

# create replication user

# mysql_net=$(ip route | awk '$1=="default" {print $3}' | sed "s/\.[0-9]\+$/.%/g")

mysql -uroot \
-e "GRANT REPLICATION SLAVE ON *.* TO 'backup'@'172.28.0.%' IDENTIFIED BY 'mytest';"
